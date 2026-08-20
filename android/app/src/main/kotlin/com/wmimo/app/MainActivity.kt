package com.wmimo.app

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.net.VpnService
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.wmimo.app/native_helper"
    private val VPN_REQUEST_CODE = 1001
    private val NOTIF_REQUEST_CODE = 1002

    private var pendingVpnResult: MethodChannel.Result? = null
    private var pendingNotifResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNativeLibraryDir" -> {
                    result.success(applicationInfo.nativeLibraryDir)
                }
                "getNativeLibraryPath" -> {
                    val libName = call.argument<String>("libName") ?: "libwmimoService.so"
                    val file = File(applicationInfo.nativeLibraryDir, libName)
                    if (file.exists()) {
                        result.success(file.absolutePath)
                    } else {
                        val dir = File(applicationInfo.nativeLibraryDir)
                        val files = dir.listFiles { _, name -> name.endsWith(".so") }
                        val found = files?.firstOrNull { it.name.contains("wmimo") || it.name.contains("clash") || it.name.contains("mihomo") }
                        result.success(found?.absolutePath ?: file.absolutePath)
                    }
                }
                "checkVpnPermission" -> {
                    val vpnIntent = VpnService.prepare(this)
                    result.success(vpnIntent == null)
                }
                "requestVpnPermission" -> {
                    val vpnIntent = VpnService.prepare(this)
                    if (vpnIntent != null) {
                        pendingVpnResult = result
                        startActivityForResult(vpnIntent, VPN_REQUEST_CODE)
                    } else {
                        result.success(true)
                    }
                }
                "checkNotificationPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        val granted = ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) == PackageManager.PERMISSION_GRANTED
                        result.success(granted)
                    } else {
                        result.success(true)
                    }
                }
                "requestNotificationPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        val granted = ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) == PackageManager.PERMISSION_GRANTED
                        if (!granted) {
                            pendingNotifResult = result
                            ActivityCompat.requestPermissions(
                                this,
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                NOTIF_REQUEST_CODE
                            )
                        } else {
                            result.success(true)
                        }
                    } else {
                        result.success(true)
                    }
                }
                "checkIgnoreBatteryOptimizations" -> {
                    val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                    val isIgnoring = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && powerManager != null) {
                        powerManager.isIgnoringBatteryOptimizations(packageName)
                    } else {
                        true
                    }
                    result.success(isIgnoring)
                }
                "requestIgnoreBatteryOptimizations" -> {
                    val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && powerManager != null) {
                        if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
                            try {
                                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                                    data = Uri.parse("package:$packageName")
                                }
                                startActivity(intent)
                                result.success(true)
                            } catch (e: Exception) {
                                try {
                                    val fallbackIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                                    startActivity(fallbackIntent)
                                    result.success(true)
                                } catch (e2: Exception) {
                                    result.success(false)
                                }
                            }
                        } else {
                            result.success(true)
                        }
                    } else {
                        result.success(true)
                    }
                }
                "startVpnService" -> {
                    val mixedPort = call.argument<Int>("mixedPort") ?: 7890
                    val intent = Intent(this, WmimoVpnService::class.java).apply {
                        action = WmimoVpnService.ACTION_START
                        putExtra("mixedPort", mixedPort)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopVpnService" -> {
                    val intent = Intent(this, WmimoVpnService::class.java).apply {
                        action = WmimoVpnService.ACTION_STOP
                    }
                    startService(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_REQUEST_CODE) {
            val isGranted = (resultCode == RESULT_OK)
            pendingVpnResult?.success(isGranted)
            pendingVpnResult = null
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == NOTIF_REQUEST_CODE) {
            val isGranted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingNotifResult?.success(isGranted)
            pendingNotifResult = null
        }
    }
}
