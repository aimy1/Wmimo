package com.wmimo.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import org.json.JSONArray
import org.json.JSONObject
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder
import java.security.SecureRandom
import java.util.Locale
import java.util.concurrent.Executors

object WmimoWidgetUpdater {
    const val PREFS_NAME = "wmimo_widget_prefs"
    private const val KEY_SNAPSHOT = "widget_snapshot"
    private const val KEY_TOKEN = "widget_action_token"
    private const val KEY_CORE_PID = "widget_core_pid"
    private const val KEY_OVERRIDE_MODE = "override_mode"
    private const val KEY_OVERRIDE_NODE = "override_node"
    private const val KEY_OVERRIDE_VPN_STOPPED = "override_vpn_stopped"

    const val ACTION_WIDGET_REFRESH = "com.wmimo.app.widget.ACTION_REFRESH"
    const val ACTION_WIDGET_TOGGLE_VPN = "com.wmimo.app.widget.ACTION_TOGGLE_VPN"
    const val ACTION_WIDGET_CYCLE_MODE = "com.wmimo.app.widget.ACTION_CYCLE_MODE"
    const val ACTION_WIDGET_SET_MODE = "com.wmimo.app.widget.ACTION_SET_MODE"
    const val ACTION_WIDGET_SWITCH_NODE = "com.wmimo.app.widget.ACTION_SWITCH_NODE"
    const val ACTION_NATIVE_WIDGET_SYNC = "com.wmimo.app.widget.ACTION_NATIVE_WIDGET_SYNC"

    const val EXTRA_MODE = "extra_mode"
    const val EXTRA_GROUP_NAME = "extra_group_name"
    const val EXTRA_NODE_NAME = "extra_node_name"
    const val EXTRA_NODE_SLOT = "extra_node_slot"

    private val ioExecutor = Executors.newSingleThreadExecutor()

    fun prefs(context: Context): SharedPreferences =
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    @Synchronized
    fun getOrCreateToken(context: Context): String {
        val sp = prefs(context)
        val existing = sp.getString(KEY_TOKEN, null)
        if (!existing.isNullOrEmpty()) {
            return existing
        }
        val bytes = ByteArray(16)
        SecureRandom().nextBytes(bytes)
        val sb = StringBuilder(32)
        for (b in bytes) {
            sb.append(String.format(Locale.US, "%02x", b))
        }
        val generated = sb.toString()
        sp.edit().putString(KEY_TOKEN, generated).apply()
        return generated
    }

    fun saveCorePid(context: Context, pid: Int) {
        prefs(context).edit().putInt(KEY_CORE_PID, pid).apply()
    }

    fun terminateOrphanedCoreIfNeeded(context: Context) {
        val sp = prefs(context)
        val pid = sp.getInt(KEY_CORE_PID, 0)
        if (pid <= 0) return
        try {
            val cmdlineFile = File("/proc/$pid/cmdline")
            if (cmdlineFile.exists()) {
                val cmdline = cmdlineFile.readText()
                if (cmdline.contains("wmimo") || cmdline.contains("clash") || cmdline.contains("mihomo")) {
                    android.os.Process.sendSignal(pid, 15) // SIGTERM
                }
            }
        } catch (_: Throwable) {}
        sp.edit().putInt(KEY_CORE_PID, 0).apply()
    }

    fun saveSnapshotAndRefresh(context: Context, snapshotJson: String) {
        prefs(context).edit().putString(KEY_SNAPSHOT, snapshotJson).apply()
        refreshAllWidgets(context)
    }

    fun loadSnapshot(context: Context): JSONObject {
        val raw = prefs(context).getString(KEY_SNAPSHOT, null)
        if (!raw.isNullOrEmpty()) {
            try {
                return JSONObject(raw)
            } catch (_: Throwable) {}
        }
        return JSONObject()
    }

    fun recordNativeOverride(
        context: Context,
        mode: String? = null,
        node: String? = null,
        vpnStopped: Boolean? = null
    ) {
        val editor = prefs(context).edit()
        if (!mode.isNullOrEmpty()) editor.putString(KEY_OVERRIDE_MODE, mode)
        if (!node.isNullOrEmpty()) editor.putString(KEY_OVERRIDE_NODE, node)
        if (vpnStopped != null) editor.putBoolean(KEY_OVERRIDE_VPN_STOPPED, vpnStopped)
        editor.apply()

        val syncIntent = Intent(ACTION_NATIVE_WIDGET_SYNC).apply {
            setPackage(context.packageName)
            if (!mode.isNullOrEmpty()) putExtra("mode", mode)
            if (!node.isNullOrEmpty()) putExtra("currentNode", node)
            if (vpnStopped != null) putExtra("vpnStopped", vpnStopped)
        }
        try {
            context.sendBroadcast(syncIntent)
        } catch (_: Throwable) {}
    }

    fun consumeNativeOverrides(context: Context): Map<String, Any> {
        val sp = prefs(context)
        val map = mutableMapOf<String, Any>()
        sp.getString(KEY_OVERRIDE_MODE, null)?.let {
            if (it.isNotEmpty()) map["mode"] = it
        }
        sp.getString(KEY_OVERRIDE_NODE, null)?.let {
            if (it.isNotEmpty()) map["currentNode"] = it
        }
        if (sp.getBoolean(KEY_OVERRIDE_VPN_STOPPED, false)) {
            map["vpnStopped"] = true
        }
        sp.edit()
            .remove(KEY_OVERRIDE_MODE)
            .remove(KEY_OVERRIDE_NODE)
            .remove(KEY_OVERRIDE_VPN_STOPPED)
            .apply()
        return map
    }

    fun onVpnServiceStateChanged(context: Context, isRunning: Boolean) {
        val snap = loadSnapshot(context)
        try {
            snap.put("connected", isRunning)
            snap.put("transitioning", false)
            snap.put("vpnState", if (isRunning) "connected" else "disconnected")
            if (!isRunning) {
                snap.put("upSpeed", 0)
                snap.put("downSpeed", 0)
                snap.put("upSpeedText", "0 B/s")
                snap.put("downSpeedText", "0 B/s")
            }
            prefs(context).edit().putString(KEY_SNAPSHOT, snap.toString()).apply()
        } catch (_: Throwable) {}
        refreshAllWidgets(context)
    }

    fun refreshAllWidgets(context: Context) {
        val appContext = context.applicationContext
        val manager = AppWidgetManager.getInstance(appContext)
        val snap = loadSnapshot(appContext)

        val statusIds = manager.getAppWidgetIds(
            ComponentName(appContext, WmimoStatusWidgetProvider::class.java)
        )
        for (id in statusIds) {
            manager.updateAppWidget(id, buildStatusRemoteViews(appContext, snap))
        }

        val trafficIds = manager.getAppWidgetIds(
            ComponentName(appContext, WmimoTrafficWidgetProvider::class.java)
        )
        for (id in trafficIds) {
            manager.updateAppWidget(id, buildTrafficRemoteViews(appContext, snap))
        }

        val qsIds = manager.getAppWidgetIds(
            ComponentName(appContext, WmimoQuickSwitchWidgetProvider::class.java)
        )
        for (id in qsIds) {
            manager.updateAppWidget(id, buildQuickSwitchRemoteViews(appContext, snap))
        }

        TileService.requestTileUpdate(appContext)
    }

    private fun label(context: Context, snap: JSONObject, key: String, fallbackRes: Int): String {
        val labels = snap.optJSONObject("labels")
        val fromSnap = labels?.optString(key, "") ?: ""
        return if (fromSnap.isNotEmpty()) fromSnap else context.getString(fallbackRes)
    }

    private fun isEffectiveConnected(snap: JSONObject): Boolean {
        return WmimoVpnService.isServiceRunning || snap.optBoolean("connected", false)
    }

    private fun statusColor(context: Context, connected: Boolean, transitioning: Boolean): Int {
        return when {
            connected -> ContextCompat.getColor(context, R.color.widget_green)
            transitioning -> ContextCompat.getColor(context, R.color.widget_accent)
            else -> ContextCompat.getColor(context, R.color.widget_grey)
        }
    }

    private fun delayColor(context: Context, delay: Int): Int {
        return when {
            delay <= 0 -> ContextCompat.getColor(context, R.color.widget_text_secondary)
            delay < 300 -> ContextCompat.getColor(context, R.color.widget_green)
            delay < 800 -> ContextCompat.getColor(context, R.color.widget_amber)
            else -> ContextCompat.getColor(context, R.color.widget_red)
        }
    }

    private fun modeDisplayText(context: Context, snap: JSONObject, mode: String): String {
        return when (mode.lowercase(Locale.US)) {
            "global" -> label(context, snap, "modeGlobal", R.string.widget_mode_global)
            "direct" -> label(context, snap, "modeDirect", R.string.widget_mode_direct)
            else -> label(context, snap, "modeRule", R.string.widget_mode_rule)
        }
    }

    fun buildStatusRemoteViews(context: Context, snap: JSONObject): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_status)
        val connected = isEffectiveConnected(snap)
        val transitioning = snap.optBoolean("transitioning", false)

        val stateText = when {
            transitioning -> label(context, snap, "connecting", R.string.tile_connected)
            connected -> label(context, snap, "connected", R.string.tile_connected)
            else -> label(context, snap, "disconnected", R.string.tile_disconnected)
        }
        views.setTextViewText(R.id.widget_status_state_text, stateText)
        views.setInt(
            R.id.widget_status_dot,
            "setColorFilter",
            statusColor(context, connected, transitioning)
        )

        val mode = snap.optString("mode", "rule")
        views.setTextViewText(R.id.widget_status_mode_btn, modeDisplayText(context, snap, mode))

        views.setInt(
            R.id.widget_status_toggle_btn,
            "setBackgroundResource",
            if (connected) R.drawable.widget_toggle_on_bg else R.drawable.widget_toggle_off_bg
        )
        views.setInt(
            R.id.widget_status_toggle_btn,
            "setColorFilter",
            if (connected) 0xFFFFFFFF.toInt() else ContextCompat.getColor(context, R.color.widget_text_primary)
        )

        val nodeName = snap.optString("currentNodeDisplay", "").ifEmpty {
            snap.optString("currentNode", "").ifEmpty {
                label(context, snap, "noNodes", R.string.widget_no_nodes)
            }
        }
        val profileName = snap.optString("profileName", "").ifEmpty {
            label(context, snap, "noProfile", R.string.widget_no_profile)
        }
        views.setTextViewText(R.id.widget_status_node_name, nodeName)
        views.setTextViewText(R.id.widget_status_profile_name, profileName)

        val delay = snap.optInt("currentDelay", 0)
        if (delay > 0) {
            views.setViewVisibility(R.id.widget_status_delay_badge, View.VISIBLE)
            views.setTextViewText(R.id.widget_status_delay_badge, "$delay ms")
            views.setTextColor(R.id.widget_status_delay_badge, delayColor(context, delay))
        } else {
            views.setViewVisibility(R.id.widget_status_delay_badge, View.GONE)
        }

        val upSpeed = if (connected) snap.optString("upSpeedText", "0 B/s") else "0 B/s"
        val downSpeed = if (connected) snap.optString("downSpeedText", "0 B/s") else "0 B/s"
        views.setTextViewText(R.id.widget_status_up_speed, "↑ $upSpeed")
        views.setTextViewText(R.id.widget_status_down_speed, "↓ $downSpeed")

        // PendingIntents
        views.setOnClickPendingIntent(
            R.id.widget_status_root,
            buildOpenAppPendingIntent(context, "home", 100)
        )
        views.setOnClickPendingIntent(
            R.id.widget_status_node_card,
            buildOpenAppPendingIntent(context, "proxies", 101)
        )
        views.setOnClickPendingIntent(
            R.id.widget_status_mode_btn,
            buildBroadcastPendingIntent(
                context,
                 WmimoStatusWidgetProvider::class.java,
                ACTION_WIDGET_CYCLE_MODE,
                102
            )
        )
        views.setOnClickPendingIntent(
            R.id.widget_status_refresh_btn,
            buildBroadcastPendingIntent(
                context,
                WmimoStatusWidgetProvider::class.java,
                ACTION_WIDGET_REFRESH,
                103
            )
        )
        views.setOnClickPendingIntent(
            R.id.widget_status_toggle_btn,
            if (connected) {
                buildBroadcastPendingIntent(
                    context,
                    WmimoStatusWidgetProvider::class.java,
                    ACTION_WIDGET_TOGGLE_VPN,
                    104
                )
            } else {
                buildConnectAppPendingIntent(context, 105)
            }
        )

        return views
    }

    fun buildTrafficRemoteViews(context: Context, snap: JSONObject): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_traffic)
        val connected = isEffectiveConnected(snap)
        val transitioning = snap.optBoolean("transitioning", false)

        views.setInt(
            R.id.widget_traffic_dot,
            "setColorFilter",
            statusColor(context, connected, transitioning)
        )
        views.setTextViewText(
            R.id.widget_traffic_title,
            label(context, snap, "trafficTitle", R.string.widget_traffic_title)
        )
        val profileName = snap.optString("profileName", "").ifEmpty {
            label(context, snap, "noProfile", R.string.widget_no_profile)
        }
        views.setTextViewText(R.id.widget_traffic_profile, profileName)

        val downLabel = label(context, snap, "download", R.string.widget_download)
        val upLabel = label(context, snap, "upload", R.string.widget_upload)
        views.setTextViewText(R.id.widget_traffic_down_label, "↓ $downLabel")
        views.setTextViewText(R.id.widget_traffic_up_label, "↑ $upLabel")

        val downSpeed = if (connected) snap.optString("downSpeedText", "0 B/s") else "0 B/s"
        val upSpeed = if (connected) snap.optString("upSpeedText", "0 B/s") else "0 B/s"
        views.setTextViewText(R.id.widget_traffic_down_speed, downSpeed)
        views.setTextViewText(R.id.widget_traffic_up_speed, upSpeed)

        val downTotal = snap.optString("downTotalText", "0 B")
        val upTotal = snap.optString("upTotalText", "0 B")
        views.setTextViewText(R.id.widget_traffic_down_total, downTotal)
        views.setTextViewText(R.id.widget_traffic_up_total, upTotal)

        val subTotal = snap.optLong("subTotal", 0L)
        if (subTotal > 0L) {
            val subUsedText = snap.optString("subUsedText", "0 B")
            val subTotalText = snap.optString("subTotalText", "0 B")
            val subPercent = snap.optInt("subPercent", 0).coerceIn(0, 100)
            val quotaLabel = label(context, snap, "quota", R.string.widget_quota)
            views.setTextViewText(
                R.id.widget_traffic_quota_text,
                "$quotaLabel: $subUsedText / $subTotalText"
            )
            views.setTextViewText(R.id.widget_traffic_quota_percent, "$subPercent%")
            views.setViewVisibility(R.id.widget_traffic_quota_bar, View.VISIBLE)
            views.setProgressBar(R.id.widget_traffic_quota_bar, 100, subPercent, false)
        } else {
            val sessionLabel = label(context, snap, "sessionTotal", R.string.widget_session_total)
            val sessionTotal = snap.optString("sessionTotalText", "0 B")
            views.setTextViewText(
                R.id.widget_traffic_quota_text,
                "$sessionLabel: $sessionTotal"
            )
            views.setTextViewText(
                R.id.widget_traffic_quota_percent,
                snap.optString("currentNode", "")
            )
            views.setViewVisibility(R.id.widget_traffic_quota_bar, View.GONE)
        }

        views.setOnClickPendingIntent(
            R.id.widget_traffic_root,
            buildOpenAppPendingIntent(context, "connections", 200)
        )
        views.setOnClickPendingIntent(
            R.id.widget_traffic_refresh_btn,
            buildBroadcastPendingIntent(
                context,
                WmimoTrafficWidgetProvider::class.java,
                ACTION_WIDGET_REFRESH,
                201
            )
        )
        return views
    }

    fun buildQuickSwitchRemoteViews(context: Context, snap: JSONObject): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_quick_switch)
        val connected = isEffectiveConnected(snap)
        val transitioning = snap.optBoolean("transitioning", false)

        views.setInt(
            R.id.widget_qs_dot,
            "setColorFilter",
            statusColor(context, connected, transitioning)
        )

        val profileName = snap.optString("profileName", "").ifEmpty {
            label(context, snap, "quickSwitchTitle", R.string.widget_quick_switch_title)
        }
        views.setTextViewText(R.id.widget_qs_profile_btn, profileName)

        // Outbound Mode Pills
        val currentMode = snap.optString("mode", "rule").lowercase(Locale.US)
        val accentColor = ContextCompat.getColor(context, R.color.widget_accent)
        val secondaryColor = ContextCompat.getColor(context, R.color.widget_text_secondary)

        val modes = listOf(
            Triple(R.id.widget_qs_mode_rule, "rule", label(context, snap, "modeRule", R.string.widget_mode_rule)),
            Triple(R.id.widget_qs_mode_global, "global", label(context, snap, "modeGlobal", R.string.widget_mode_global)),
            Triple(R.id.widget_qs_mode_direct, "direct", label(context, snap, "modeDirect", R.string.widget_mode_direct))
        )
        for ((idx, triple) in modes.withIndex()) {
            val (btnId, modeVal, modeText) = triple
            val active = currentMode == modeVal
            views.setTextViewText(btnId, modeText)
            views.setInt(
                btnId,
                "setBackgroundResource",
                if (active) R.drawable.widget_pill_active_bg else R.drawable.widget_pill_bg
            )
            views.setTextColor(btnId, if (active) accentColor else secondaryColor)
            views.setOnClickPendingIntent(
                btnId,
                buildBroadcastPendingIntent(
                    context,
                    WmimoQuickSwitchWidgetProvider::class.java,
                    ACTION_WIDGET_SET_MODE,
                    310 + idx
                ) {
                    putExtra(EXTRA_MODE, modeVal)
                }
            )
        }

        // Power Toggle
        views.setInt(
            R.id.widget_qs_toggle_btn,
            "setBackgroundResource",
            if (connected) R.drawable.widget_toggle_on_bg else R.drawable.widget_toggle_off_bg
        )
        views.setInt(
            R.id.widget_qs_toggle_btn,
            "setColorFilter",
            if (connected) 0xFFFFFFFF.toInt() else ContextCompat.getColor(context, R.color.widget_text_primary)
        )
        views.setOnClickPendingIntent(
            R.id.widget_qs_toggle_btn,
            if (connected) {
                buildBroadcastPendingIntent(
                    context,
                    WmimoQuickSwitchWidgetProvider::class.java,
                    ACTION_WIDGET_TOGGLE_VPN,
                    301
                )
            } else {
                buildConnectAppPendingIntent(context, 302)
            }
        )

        views.setOnClickPendingIntent(
            R.id.widget_qs_root,
            buildOpenAppPendingIntent(context, "proxies", 300)
        )
        views.setOnClickPendingIntent(
            R.id.widget_qs_profile_btn,
            buildOpenAppPendingIntent(context, "profiles", 303)
        )
        views.setOnClickPendingIntent(
            R.id.widget_qs_refresh_btn,
            buildBroadcastPendingIntent(
                context,
                WmimoQuickSwitchWidgetProvider::class.java,
                ACTION_WIDGET_REFRESH,
                304
            )
        )

        // 4 Quick-Switch Node Slots
        val slotIds = listOf(
            Triple(R.id.widget_qs_node_1, R.id.widget_qs_node_1_name, R.id.widget_qs_node_1_delay),
            Triple(R.id.widget_qs_node_2, R.id.widget_qs_node_2_name, R.id.widget_qs_node_2_delay),
            Triple(R.id.widget_qs_node_3, R.id.widget_qs_node_3_name, R.id.widget_qs_node_3_delay),
            Triple(R.id.widget_qs_node_4, R.id.widget_qs_node_4_name, R.id.widget_qs_node_4_delay)
        )

        val nodesArray = snap.optJSONArray("nodes") ?: JSONArray()
        val currentNode = snap.optString("currentNode", "")
        val groupName = snap.optString("groupName", "节点选择").ifEmpty { "节点选择" }
        val noNodesText = label(context, snap, "noNodes", R.string.widget_no_nodes)

        for (i in slotIds.indices) {
            val (boxId, nameId, delayId) = slotIds[i]
            val nodeObj = if (i < nodesArray.length()) nodesArray.optJSONObject(i) else null
            if (nodeObj != null) {
                val nName = nodeObj.optString("name", "")
                val nDisplay = nodeObj.optString("displayName", "").ifEmpty { nName }
                val nDelay = nodeObj.optInt("delay", 0)
                val isSelected = nodeObj.optBoolean("selected", false) ||
                    (currentNode.isNotEmpty() && nName == currentNode)

                views.setTextViewText(nameId, nDisplay)
                if (nDelay > 0) {
                    views.setTextViewText(delayId, "${nDelay}ms")
                    views.setTextColor(delayId, delayColor(context, nDelay))
                } else {
                    views.setTextViewText(delayId, "")
                }
                views.setInt(
                    boxId,
                    "setBackgroundResource",
                    if (isSelected) R.drawable.widget_node_item_active_bg else R.drawable.widget_node_item_bg
                )
                views.setOnClickPendingIntent(
                    boxId,
                    buildBroadcastPendingIntent(
                        context,
                        WmimoQuickSwitchWidgetProvider::class.java,
                        ACTION_WIDGET_SWITCH_NODE,
                        320 + i
                    ) {
                        putExtra(EXTRA_GROUP_NAME, groupName)
                        putExtra(EXTRA_NODE_NAME, nName)
                        putExtra(EXTRA_NODE_SLOT, i)
                    }
                )
            } else {
                views.setTextViewText(nameId, if (i == 0) noNodesText else "--")
                views.setTextViewText(delayId, "")
                views.setInt(boxId, "setBackgroundResource", R.drawable.widget_node_item_bg)
                views.setOnClickPendingIntent(
                    boxId,
                    buildOpenAppPendingIntent(context, "proxies", 330 + i)
                )
            }
        }

        return views
    }

    private fun buildOpenAppPendingIntent(
        context: Context,
        tab: String,
        requestCode: Int
    ): PendingIntent {
        val token = getOrCreateToken(context)
        val uri = Uri.parse("wmimo://widget?action=open&tab=$tab&token=$token")
        val intent = Intent(Intent.ACTION_VIEW, uri, context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun buildConnectAppPendingIntent(
        context: Context,
        requestCode: Int
    ): PendingIntent {
        val token = getOrCreateToken(context)
        val uri = Uri.parse("wmimo://widget?action=connect&background=true&token=$token")
        val intent = Intent(Intent.ACTION_VIEW, uri, context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun buildBroadcastPendingIntent(
        context: Context,
        receiverClass: Class<*>,
        action: String,
        requestCode: Int,
        extras: (Intent.() -> Unit)? = null
    ): PendingIntent {
        val intent = Intent(context, receiverClass).apply {
            this.action = action
            extras?.invoke(this)
        }
        return PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    fun handleBroadcastActionAsync(
        context: Context,
        intent: Intent,
        pendingResult: android.content.BroadcastReceiver.PendingResult?
    ) {
        val appContext = context.applicationContext
        val action = intent.action ?: run {
            pendingResult?.finish()
            return
        }

        ioExecutor.execute {
            try {
                when (action) {
                    ACTION_WIDGET_TOGGLE_VPN -> {
                        if (WmimoVpnService.isServiceRunning) {
                            val stopIntent = Intent(appContext, WmimoVpnService::class.java).apply {
                                this.action = WmimoVpnService.ACTION_STOP
                            }
                            appContext.startService(stopIntent)
                            recordNativeOverride(appContext, vpnStopped = true)
                            onVpnServiceStateChanged(appContext, false)
                        }
                    }

                    ACTION_WIDGET_CYCLE_MODE -> {
                        val snap = loadSnapshot(appContext)
                        val cur = snap.optString("mode", "rule").lowercase(Locale.US)
                        val next = when (cur) {
                            "rule" -> "global"
                            "global" -> "direct"
                            else -> "rule"
                        }
                        applyModeFromWidget(appContext, snap, next)
                    }

                    ACTION_WIDGET_SET_MODE -> {
                        val targetMode = intent.getStringExtra(EXTRA_MODE)?.lowercase(Locale.US) ?: "rule"
                        val snap = loadSnapshot(appContext)
                        applyModeFromWidget(appContext, snap, targetMode)
                    }

                    ACTION_WIDGET_SWITCH_NODE -> {
                        val groupName = intent.getStringExtra(EXTRA_GROUP_NAME) ?: "节点选择"
                        val nodeName = intent.getStringExtra(EXTRA_NODE_NAME) ?: ""
                        if (nodeName.isNotEmpty()) {
                            val snap = loadSnapshot(appContext)
                            applyNodeSwitchFromWidget(appContext, snap, groupName, nodeName)
                        }
                    }

                    ACTION_WIDGET_REFRESH -> {
                        val snap = loadSnapshot(appContext)
                        refreshLiveCoreMetrics(appContext, snap)
                    }
                }
            } catch (_: Throwable) {
            } finally {
                try {
                    pendingResult?.finish()
                } catch (_: Throwable) {}
            }
        }
    }

    private fun applyModeFromWidget(context: Context, snap: JSONObject, mode: String) {
        val port = snap.optInt("controlPort", 9090).let { if (it <= 0) 9090 else it }
        val secret = snap.optString("controlSecret", "")
        if (isEffectiveConnected(snap)) {
            httpRequest(
                url = "http://127.0.0.1:$port/configs",
                method = "PATCH",
                secret = secret,
                body = JSONObject().put("mode", mode).toString()
            )
        }
        snap.put("mode", mode)
        prefs(context).edit().putString(KEY_SNAPSHOT, snap.toString()).apply()
        recordNativeOverride(context, mode = mode)
        refreshAllWidgets(context)
    }

    private fun applyNodeSwitchFromWidget(
        context: Context,
        snap: JSONObject,
        groupName: String,
        nodeName: String
    ) {
        val port = snap.optInt("controlPort", 9090).let { if (it <= 0) 9090 else it }
        val secret = snap.optString("controlSecret", "")
        if (isEffectiveConnected(snap)) {
            val encodedGroup = URLEncoder.encode(groupName, "UTF-8").replace("+", "%20")
            val body = JSONObject().put("name", nodeName).toString()
            httpRequest(
                url = "http://127.0.0.1:$port/proxies/$encodedGroup",
                method = "PUT",
                secret = secret,
                body = body
            )
            if (groupName != "GLOBAL") {
                httpRequest(
                    url = "http://127.0.0.1:$port/proxies/GLOBAL",
                    method = "PUT",
                    secret = secret,
                    body = body
                )
            }
        }

        snap.put("currentNode", nodeName)
        var resolvedDisplay = nodeName
        val nodes = snap.optJSONArray("nodes")
        if (nodes != null) {
            for (i in 0 until nodes.length()) {
                val item = nodes.optJSONObject(i) ?: continue
                val isTarget = item.optString("name") == nodeName
                item.put("selected", isTarget)
                if (isTarget) {
                    val disp = item.optString("displayName", "")
                    if (disp.isNotEmpty()) resolvedDisplay = disp
                    val d = item.optInt("delay", 0)
                    if (d > 0) snap.put("currentDelay", d)
                }
            }
        }
        snap.put("currentNodeDisplay", resolvedDisplay)
        prefs(context).edit().putString(KEY_SNAPSHOT, snap.toString()).apply()
        recordNativeOverride(context, node = nodeName)
        refreshAllWidgets(context)
    }

    private fun refreshLiveCoreMetrics(context: Context, snap: JSONObject) {
        if (!isEffectiveConnected(snap)) {
            onVpnServiceStateChanged(context, false)
            return
        }
        val port = snap.optInt("controlPort", 9090).let { if (it <= 0) 9090 else it }
        val secret = snap.optString("controlSecret", "")

        // 1. Fetch /connections for session uploadTotal & downloadTotal
        val connStr = httpRequest("http://127.0.0.1:$port/connections", "GET", secret)
        if (!connStr.isNullOrEmpty()) {
            try {
                val connJson = JSONObject(connStr)
                val upTotal = connJson.optLong("uploadTotal", 0L)
                val downTotal = connJson.optLong("downloadTotal", 0L)
                snap.put("upTotal", upTotal)
                snap.put("downTotal", downTotal)
                snap.put("upTotalText", formatBytes(upTotal))
                snap.put("downTotalText", formatBytes(downTotal))
                snap.put("sessionTotalText", formatBytes(upTotal + downTotal))
            } catch (_: Throwable) {}
        }

        // 2. Read single line from /traffic stream for instantaneous speed
        val trafficLine = readFirstStreamLine("http://127.0.0.1:$port/traffic", secret)
        if (!trafficLine.isNullOrEmpty()) {
            try {
                val tJson = JSONObject(trafficLine)
                val up = tJson.optLong("up", 0L)
                val down = tJson.optLong("down", 0L)
                snap.put("upSpeed", up)
                snap.put("downSpeed", down)
                snap.put("upSpeedText", "${formatBytes(up)}/s")
                snap.put("downSpeedText", "${formatBytes(down)}/s")
            } catch (_: Throwable) {}
        }

        prefs(context).edit().putString(KEY_SNAPSHOT, snap.toString()).apply()
        refreshAllWidgets(context)
    }

    private fun httpRequest(
        url: String,
        method: String,
        secret: String,
        body: String? = null
    ): String? {
        var conn: HttpURLConnection? = null
        return try {
            conn = (URL(url).openConnection() as HttpURLConnection).apply {
                requestMethod = method
                connectTimeout = 1200
                readTimeout = 1500
                if (secret.isNotEmpty()) {
                    setRequestProperty("Authorization", "Bearer $secret")
                }
                if (body != null) {
                    doOutput = true
                    setRequestProperty("Content-Type", "application/json; charset=UTF-8")
                    OutputStreamWriter(outputStream, Charsets.UTF_8).use {
                        it.write(body)
                        it.flush()
                    }
                }
            }
            val code = conn.responseCode
            if (code in 200..299) {
                BufferedReader(InputStreamReader(conn.inputStream, Charsets.UTF_8)).use {
                    it.readText()
                }
            } else {
                null
            }
        } catch (_: Throwable) {
            null
        } finally {
            try {
                conn?.disconnect()
            } catch (_: Throwable) {}
        }
    }

    private fun readFirstStreamLine(url: String, secret: String): String? {
        var conn: HttpURLConnection? = null
        return try {
            conn = (URL(url).openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 800
                readTimeout = 1300
                if (secret.isNotEmpty()) {
                    setRequestProperty("Authorization", "Bearer $secret")
                }
            }
            if (conn.responseCode in 200..299) {
                BufferedReader(InputStreamReader(conn.inputStream, Charsets.UTF_8)).use { reader ->
                    reader.readLine()
                }
            } else {
                null
            }
        } catch (_: Throwable) {
            null
        } finally {
            try {
                conn?.disconnect()
            } catch (_: Throwable) {}
        }
    }

    fun formatBytes(bytes: Long): String {
        if (bytes <= 0L) return "0 B"
        val kb = 1024.0
        val mb = kb * 1024.0
        val gb = mb * 1024.0
        val tb = gb * 1024.0
        return when {
            bytes >= tb -> String.format(Locale.US, "%.1f TB", bytes / tb)
            bytes >= gb -> String.format(Locale.US, "%.1f GB", bytes / gb)
            bytes >= mb -> String.format(Locale.US, "%.1f MB", bytes / mb)
            bytes >= kb -> String.format(Locale.US, "%.1f KB", bytes / kb)
            else -> "$bytes B"
        }
    }
}
