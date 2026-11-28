package com.wmimo.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.ProxyInfo
import android.net.VpnService
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import androidx.core.app.NotificationCompat
import java.io.File
import java.net.InetSocketAddress
import java.net.Socket

class WmimoVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null
    private var isRunning = false
    private var mixedPort = 7890
    private var perAppEnable = false
    private var perAppWhitelist = false
    private var perAppPackages: ArrayList<String> = ArrayList()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var consecutiveDeadChecks = 0

    private val coreWatchdogRunnable = object : Runnable {
        override fun run() {
            if (!isRunning) return
            Thread {
                val alive = isCorePortListening(mixedPort)
                mainHandler.post {
                    if (!isRunning) return@post
                    if (alive) {
                        consecutiveDeadChecks = 0
                        mainHandler.postDelayed(this, 2500L)
                    } else {
                        consecutiveDeadChecks++
                        if (consecutiveDeadChecks >= 2) {
                            stopVpn()
                        } else {
                            mainHandler.postDelayed(this, 1500L)
                        }
                    }
                }
            }.start()
        }
    }

    private fun isCorePortListening(port: Int): Boolean {
        if (port <= 0) return false
        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress("127.0.0.1", port), 400)
                true
            }
        } catch (_: Throwable) {
            false
        }
    }

    companion object {
        const val ACTION_START = "com.wmimo.app.vpn.START"
        const val ACTION_STOP = "com.wmimo.app.vpn.STOP"
        const val ACTION_UPDATE = "com.wmimo.app.vpn.UPDATE"
        const val NOTIFICATION_CHANNEL_ID = "wmimo_vpn_channel"
        const val NOTIFICATION_ID = 10001
        var isServiceRunning = false
            private set
        var currentNotificationContent: String? = null
        var currentNotificationDisconnect: String? = null
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: ACTION_START
        mixedPort = intent?.getIntExtra("mixedPort", 7890) ?: 7890
        perAppEnable = intent?.getBooleanExtra("perAppEnable", false) ?: false
        perAppWhitelist = intent?.getBooleanExtra("perAppWhitelist", false) ?: false
        intent?.getStringArrayListExtra("perAppPackages")?.let {
            perAppPackages = it
        }
        intent?.getStringExtra("notificationContent")?.let {
            if (it.isNotEmpty()) currentNotificationContent = it
        }
        intent?.getStringExtra("notificationDisconnect")?.let {
            if (it.isNotEmpty()) currentNotificationDisconnect = it
        }
        when (action) {
            ACTION_START -> startVpn()
            ACTION_STOP -> stopVpn()
            ACTION_UPDATE -> updateNotification()
        }
        return START_NOT_STICKY
    }

    private fun updateNotification() {
        if (!isRunning) return
        val manager = getSystemService(NotificationManager::class.java)
        manager?.notify(NOTIFICATION_ID, createNotification())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Wmimo VPN Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Wmimo VPN foreground service notification"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val stopIntent = Intent(this, WmimoVpnService::class.java).apply {
            this.action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this,
            1,
            stopIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val title = getString(R.string.app_name)
        val content = currentNotificationContent ?: getString(R.string.notif_vpn_connected)
        val disconnect = currentNotificationDisconnect ?: getString(R.string.notif_action_disconnect)

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(R.drawable.ic_statusbar)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .addAction(0, disconnect, stopPendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun startVpn() {
        try {
            val builder = Builder()
                .setSession("Wmimo")
                .setMtu(1500)
                .addAddress("172.19.0.1", 30)
                .addDnsServer("223.5.5.5")
                .addDnsServer("1.1.1.1")

            var applyHttpProxy = true

            // Apply Per-App routing configuration
            if (perAppEnable) {
                if (perAppWhitelist) {
                    // Whitelist mode: ONLY route valid selected applications through the VPN
                    var allowedCount = 0
                    for (pkg in perAppPackages) {
                        if (pkg.isNotEmpty() && pkg != packageName) {
                            try {
                                builder.addAllowedApplication(pkg)
                                allowedCount++
                            } catch (_: Exception) {}
                        }
                    }
                    if (allowedCount == 0) {
                        // Empty whitelist must NOT fall back to proxying all apps
                        applyHttpProxy = false
                        try {
                            builder.addDisallowedApplication(packageName)
                        } catch (_: Exception) {}
                    }
                } else {
                    // Blacklist mode: Bypass selected applications, and always bypass Wmimo itself
                    try {
                        builder.addDisallowedApplication(packageName)
                    } catch (_: Exception) {}
                    for (pkg in perAppPackages) {
                        if (pkg.isNotEmpty() && pkg != packageName) {
                            try {
                                builder.addDisallowedApplication(pkg)
                            } catch (_: Exception) {}
                        }
                    }
                }
            } else {
                // Default mode: Route all applications through the VPN, disallowing Wmimo itself
                try {
                    builder.addDisallowedApplication(packageName)
                } catch (_: Exception) {}
            }

            // On Android 10+ (API 29+), set direct system HTTP proxy to Mihomo mixed-port
            if (applyHttpProxy && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                try {
                    builder.setHttpProxy(ProxyInfo.buildDirectProxy("127.0.0.1", mixedPort))
                } catch (_: Exception) {}
            }

            if (!isRunning) {
                startForeground(NOTIFICATION_ID, createNotification())
            }

            val oldInterface = vpnInterface
            val newInterface = builder.establish()
            if (newInterface != null) {
                vpnInterface = newInterface
                try {
                    oldInterface?.close()
                } catch (_: Exception) {}
                isRunning = true
                isServiceRunning = true
                consecutiveDeadChecks = 0
                mainHandler.removeCallbacks(coreWatchdogRunnable)
                mainHandler.postDelayed(coreWatchdogRunnable, 3000L)
                WmimoWidgetUpdater.onVpnServiceStateChanged(this, true)
                notifyTileStateChanged(true)
            } else if (!isRunning) {
                stopVpn()
            }
        } catch (e: Exception) {
            if (!isRunning) {
                stopVpn()
            }
        }
    }

    private fun stopVpn() {
        mainHandler.removeCallbacks(coreWatchdogRunnable)
        consecutiveDeadChecks = 0
        isRunning = false
        isServiceRunning = false
        currentNotificationContent = null
        currentNotificationDisconnect = null
        WmimoWidgetUpdater.terminateOrphanedCoreIfNeeded(this)
        WmimoWidgetUpdater.onVpnServiceStateChanged(this, false)
        notifyTileStateChanged(false)
        try {
            vpnInterface?.close()
            vpnInterface = null
        } catch (_: Exception) {}

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }

    private fun notifyTileStateChanged(connected: Boolean) {
        try {
            val action = if (connected) TileService.ACTION_START_RESULT else TileService.ACTION_STOPED
            val broadcast = Intent(action).apply {
                setPackage(packageName)
                if (connected) putExtra("err", "")
            }
            sendBroadcast(broadcast)
            TileService.requestTileUpdate(this)
        } catch (_: Throwable) {}
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        stopVpn()
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }

    override fun onRevoke() {
        stopVpn()
        super.onRevoke()
    }
}
