package com.wmimo.app

import android.app.ActivityManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import androidx.annotation.RequiresApi
import java.io.File

@RequiresApi(24)
class TileService : TileService() {
    companion object {
        const val profile_file_name = "vpn_profile.txt"
        const val service_file_name = "service.json"

        const val VPN_SERVICE_CLASS = "com.wmimo.app.WmimoVpnService"
        const val ACTION_START = "com.wmimo.app.vpn.START"
        const val ACTION_STOP = "com.wmimo.app.vpn.STOP"
        const val ACTION_START_RESULT = "com.wmimo.app.vpn.START_RESULT"
        const val ACTION_STOPED = "com.wmimo.app.vpn.STOPPED"
    }

    private var receiverRegistered = false
    private val receiver =
            object : BroadcastReceiver() {
                override fun onReceive(
                        context: Context,
                        intent: Intent,
                ) {
                    when (intent.action) {
                        ACTION_START_RESULT -> {
                            val err = intent.getStringExtra("err")
                            updateTile(err == "")
                        }
                        ACTION_STOPED -> {
                            updateTile(false)
                        }
                    }
                }
            }

    override fun onCreate() {
        if (!receiverRegistered) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                var intentFilter = IntentFilter()
                intentFilter.addAction(ACTION_STOPED)
                intentFilter.addAction(ACTION_START_RESULT)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    registerReceiver(receiver, intentFilter, Context.RECEIVER_EXPORTED)
                } else {
                    registerReceiver(receiver, intentFilter)
                }
                receiverRegistered = true
            }
        }
        super.onCreate()
    }

    override fun onDestroy() {
        if (receiverRegistered) {
            receiverRegistered = false
            unregisterReceiver(receiver)
        }
        super.onDestroy()
    }

    override fun onClick() {
        if (isRuning()) {
            var intent =
                    Intent().apply {
                        action = ACTION_STOP
                    }
            intent.setClassName(
                    getPackageName(),
                    VPN_SERVICE_CLASS
            )
            intent.putExtra("exitProcess", true)
            startService(intent)
            // stopService(intent)
            updateTile(false)
            return
        }

        try {
            updateTile(true)
            startByService()
        } catch (e: Exception) {
            var stackTrace = e.getStackTrace().joinToString(separator = "\n")
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
        return profileFile().exists() && serviceFile().exists()
    }

    private fun update() {
        if (isRuning()) {
            updateTile(true)
            return
        }
        val valid = if (isValid()) false else null
        updateTile(valid)
    }

    private fun updateTile(active: Boolean?) {
        qsTile?.apply {
            state =
                    when (active) {
                        true -> Tile.STATE_ACTIVE
                        false -> Tile.STATE_INACTIVE
                        else -> Tile.STATE_UNAVAILABLE
                    }
            updateTile()
        }
    }

    private fun startByService() {
        var intent =
                Intent().apply { action = ACTION_START }
        intent.setClassName(
                getPackageName(),
                VPN_SERVICE_CLASS
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun startByLaunch() {
        var intent = Intent()
        intent.setClassName(getPackageName(), MainActivity::class.java.name)
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.putExtra("command", "connect")
        if (Build.VERSION.SDK_INT < 34) {
            startActivityAndCollapse(intent)
        } else {
            startActivityAndCollapse(
                    PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)
            )
        }
    }

    private fun startBy() {
        if (!isMainProcessRunning()) {
            startByLaunch()
        } else {
            startByService()
        }
    }

    private fun isMainRuning(): Boolean = isServiceRuning(MainActivity::class.java.name)

    private fun isRuning(): Boolean =
            isServiceRuning(VPN_SERVICE_CLASS)

    private fun isServiceRuning(serviceName: String): Boolean {
        try {
            val packageName = getPackageName()
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val services = activityManager.getRunningServices(Integer.MAX_VALUE)
            for (runningServiceInfo in services) {
                if (runningServiceInfo.service.getPackageName().equals(packageName)) {
                    if (runningServiceInfo.service.getClassName().equals(serviceName)) {
                        return runningServiceInfo.started
                    }
                }
            }
        } catch (e: Exception) {
            var stackTrace = e.getStackTrace().joinToString(separator = "\n")
            writeLog("TileService isServiceRuning: exception: $e \n$stackTrace")
        }

        return false
    }

    fun isMainProcessRunning(): Boolean {
        val packageName = getPackageName()
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningApps = activityManager.runningAppProcesses ?: return false
        for (procInfo in runningApps) {
            if (procInfo.processName == packageName) {
                return true
            }
        }
        return false
    }

    private fun serviceFile(): File {
        val context = this as Context
        return File(context.getFilesDir(), service_file_name)
    }

    private fun profileFile(): File {
        val context = this as Context
        return File(context.getFilesDir(), profile_file_name)
    }

    private fun writeLog(message: String) {
        print("TileService writeLog: $message\n")
    }
}
