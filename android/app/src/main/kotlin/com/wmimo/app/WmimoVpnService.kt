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
import android.os.ParcelFileDescriptor
import androidx.core.app.NotificationCompat
import java.io.File

class WmimoVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null
    private var isRunning = false
    private var mixedPort = 7890

    companion object {
        const val ACTION_START = "com.wmimo.app.vpn.START"
        const val ACTION_STOP = "com.wmimo.app.vpn.STOP"
        const val ACTION_UPDATE = "com.wmimo.app.vpn.UPDATE"
        const val NOTIFICATION_CHANNEL_ID = "wmimo_vpn_channel"
        const val NOTIFICATION_ID = 10001
        var isServiceRunning = false
            private set
        var currentNodeName: String = ""
        var currentMode: String = ""
        var currentProfileName: String = ""
        var onVpnStopCallback: (() -> Unit)? = null
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: ACTION_START
        if (intent?.hasExtra("mixedPort") == true) {
            mixedPort = intent.getIntExtra("mixedPort", mixedPort)
        }
        intent?.getStringExtra("nodeName")?.let { if (it.isNotEmpty()) currentNodeName = it }
        intent?.getStringExtra("mode")?.let { if (it.isNotEmpty()) currentMode = it }
        intent?.getStringExtra("profileName")?.let { if (it.isNotEmpty()) currentProfileName = it }

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

        val switchNodeIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            putExtra("target_screen", "proxies")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val switchNodePendingIntent = if (switchNodeIntent != null) {
            PendingIntent.getActivity(
                this,
                2,
                switchNodeIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        } else null

        val title = if (currentNodeName.isNotEmpty()) {
            "Wmimo · $currentNodeName"
        } else {
            "Wmimo"
        }

        val content = buildString {
            if (currentMode.isNotEmpty()) append(currentMode)
            if (currentProfileName.isNotEmpty()) {
                if (isNotEmpty()) append(" · ")
                append(currentProfileName)
            }
            if (isEmpty()) append("VPN 代理已连接")
        }

        val bigText = buildString {
            if (currentNodeName.isNotEmpty()) append("当前节点: $currentNodeName\n")
            if (currentMode.isNotEmpty()) append("运行模式: $currentMode · 端口: $mixedPort\n")
            if (currentProfileName.isNotEmpty()) append("配置订阅: $currentProfileName")
        }.trim()

        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSubText("已连接")
            .setSmallIcon(R.drawable.ic_statusbar)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .addAction(0, "断开连接", stopPendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)

        if (switchNodePendingIntent != null) {
            builder.addAction(0, "切换节点", switchNodePendingIntent)
        }

        if (bigText.isNotEmpty()) {
            builder.setStyle(NotificationCompat.BigTextStyle().bigText(bigText))
        }

        return builder.build()
    }

    private fun startVpn() {
        if (isRunning) return
        try {
            startForeground(NOTIFICATION_ID, createNotification())

            val builder = Builder()
                .setSession("Wmimo")
                .setMtu(1500)
                .addAddress("172.19.0.1", 30)
                .addDnsServer("223.5.5.5")
                .addDnsServer("1.1.1.1")

            // On Android 10+ (API 29+), set direct system HTTP proxy to Mihomo mixed-port
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                try {
                    builder.setHttpProxy(ProxyInfo.buildDirectProxy("127.0.0.1", mixedPort))
                } catch (_: Exception) {}
            }

            // Prevent routing Wmimo itself into the VPN loop
            try {
                builder.addDisallowedApplication(packageName)
            } catch (_: Exception) {}

            vpnInterface = builder.establish()
            isRunning = true
            isServiceRunning = true
        } catch (e: Exception) {
            stopVpn()
        }
    }

    private fun stopVpn() {
        isRunning = false
        isServiceRunning = false
        currentNodeName = ""
        currentMode = ""
        currentProfileName = ""
        onVpnStopCallback?.invoke()
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

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }

    override fun onRevoke() {
        stopVpn()
        super.onRevoke()
    }
}
