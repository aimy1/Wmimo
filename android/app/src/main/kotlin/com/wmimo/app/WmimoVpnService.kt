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
        const val NOTIFICATION_CHANNEL_ID = "wmimo_vpn_channel"
        const val NOTIFICATION_ID = 10001
        var isServiceRunning = false
            private set
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: ACTION_START
        mixedPort = intent?.getIntExtra("mixedPort", 7890) ?: 7890
        when (action) {
            ACTION_START -> startVpn()
            ACTION_STOP -> stopVpn()
        }
        return START_NOT_STICKY
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

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("Wmimo")
            .setContentText("VPN 代理已连接")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .addAction(0, "断开连接", stopPendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
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
