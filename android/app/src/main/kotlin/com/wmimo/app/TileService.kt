package com.wmimo.app

import android.app.ActivityManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import androidx.annotation.RequiresApi
import java.io.File

@RequiresApi(24)
class TileService : TileService() {
    companion object {
        const val SERVICE_FILE_NAME = "service.json"
        const val PROFILES_CONFIG_NAME = "profiles.json"

        const val VPN_SERVICE_CLASS = "com.wmimo.app.WmimoVpnService"
        const val ACTION_START = "com.wmimo.app.vpn.START"
        const val ACTION_STOP = "com.wmimo.app.vpn.STOP"
        const val ACTION_START_RESULT = "com.wmimo.app.vpn.START_RESULT"
        const val ACTION_STOPED = "com.wmimo.app.vpn.STOPPED"

        fun requestTileUpdate(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                try {
                    requestListeningState(
                        context.applicationContext,
                        ComponentName(context.applicationContext, TileService::class.java)
                    )
                } catch (_: Throwable) {}
            }
        }
    }

    private var receiverRegistered = false
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                ACTION_START_RESULT -> {
                    val err = intent.getStringExtra("err") ?: ""
                    updateTile(err.isEmpty())
                }
                ACTION_STOPED -> {
                    updateTile(false)
                }
                WmimoWidgetUpdater.ACTION_NATIVE_WIDGET_SYNC -> {
                    update()
                }
            }
        }
    }

    override fun onCreate() {
        if (!receiverRegistered) {
            val intentFilter = IntentFilter().apply {
                addAction(ACTION_STOPED)
                addAction(ACTION_START_RESULT)
                addAction(WmimoWidgetUpdater.ACTION_NATIVE_WIDGET_SYNC)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(receiver, intentFilter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                registerReceiver(receiver, intentFilter)
            }
            receiverRegistered = true
        }
        super.onCreate()
    }

    override fun onDestroy() {
        if (receiverRegistered) {
            receiverRegistered = false
            try {
                unregisterReceiver(receiver)
            } catch (_: Throwable) {}
        }
        super.onDestroy()
    }

    override fun onClick() {
        if (isRunning()) {
            val intent = Intent(this, WmimoVpnService::class.java).apply {
                action = ACTION_STOP
                putExtra("exitProcess", true)
            }
            startService(intent)
            WmimoWidgetUpdater.recordNativeOverride(this, vpnStopped = true)
            WmimoWidgetUpdater.onVpnServiceStateChanged(this, false)
            updateTile(false)
            return
        }

        try {
            startByLaunch()
        } catch (e: Exception) {
            val stackTrace = e.stackTrace.joinToString(separator = "\n")
            writeLog("TileService onClick: exception: $e \n$stackTrace")
        }
    }

    override fun onTileRemoved() {
        super.onTileRemoved()
    }

    override fun onTileAdded() {
        super.onTileAdded()
        update()
    }

    override fun onStartListening() {
        super.onStartListening()
        update()
    }

    override fun onStopListening() {
        super.onStopListening()
    }

    private fun isValid(): Boolean {
        val snap = WmimoWidgetUpdater.loadSnapshot(this)
        if (snap.optString("profileId", "").isNotEmpty() ||
            snap.optString("profileName", "").isNotEmpty()
        ) {
            return true
        }
        val appDir = File(filesDir, packageName)
        if (File(appDir, SERVICE_FILE_NAME).exists() ||
            File(appDir, PROFILES_CONFIG_NAME).exists() ||
            File(filesDir, SERVICE_FILE_NAME).exists()
        ) {
            return true
        }
        return true
    }

    private fun update() {
        if (isRunning()) {
            updateTile(true)
            return
        }
        val valid = if (isValid()) false else null
        updateTile(valid)
    }

    private fun updateTile(active: Boolean?) {
        val snap = WmimoWidgetUpdater.loadSnapshot(this)
        val nodeDisplay = snap.optString("currentNodeDisplay", "").ifEmpty {
            snap.optString("currentNode", "")
        }

        qsTile?.apply {
            state = when (active) {
                true -> Tile.STATE_ACTIVE
                false -> Tile.STATE_INACTIVE
                else -> Tile.STATE_UNAVAILABLE
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                subtitle = when (active) {
                    true -> if (nodeDisplay.isNotEmpty()) nodeDisplay else getString(R.string.tile_connected)
                    false -> getString(R.string.tile_disconnected)
                    else -> getString(R.string.tile_unavailable)
                }
            }
            icon = Icon.createWithResource(this@TileService, R.drawable.ic_tile)
            updateTile()
        }
    }

    private fun startByLaunch() {
        val token = WmimoWidgetUpdater.getOrCreateToken(this)
        val uri = Uri.parse("wmimo://widget?action=connect&background=true&token=$token")
        val intent = Intent(Intent.ACTION_VIEW, uri, this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra("command", "connect")
        }
        if (Build.VERSION.SDK_INT < 34) {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        } else {
            val pendingIntent = PendingIntent.getActivity(
                this,
                401,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            startActivityAndCollapse(pendingIntent)
        }
    }

    private fun isRunning(): Boolean {
        if (WmimoVpnService.isServiceRunning) {
            return true
        }
        return isServiceRunning(VPN_SERVICE_CLASS)
    }

    private fun isServiceRunning(serviceName: String): Boolean {
        try {
            val pkg = packageName
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            @Suppress("DEPRECATION")
            val services = activityManager.getRunningServices(Integer.MAX_VALUE)
            for (runningServiceInfo in services) {
                if (runningServiceInfo.service.packageName == pkg &&
                    runningServiceInfo.service.className == serviceName
                ) {
                    return runningServiceInfo.started
                }
            }
        } catch (e: Exception) {
            val stackTrace = e.stackTrace.joinToString(separator = "\n")
            writeLog("TileService isServiceRunning: exception: $e \n$stackTrace")
        }
        return false
    }

    private fun writeLog(message: String) {
        print("TileService writeLog: $message\n")
    }
}
