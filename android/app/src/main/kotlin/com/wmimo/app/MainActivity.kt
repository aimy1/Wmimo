package com.wmimo.app

import android.Manifest
import android.app.LocaleManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.net.VpnService
import android.os.Build
import android.os.LocaleList
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.Locale

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
                "getInstalledAppList" -> {
                    Thread {
                        try {
                            val pm = packageManager
                            val apps = pm.getInstalledApplications(0)
                            val list = ArrayList<Map<String, Any>>()
                            for (app in apps) {
                                val pkg = app.packageName ?: continue
                                if (pkg == packageName) continue
                                val name = try {
                                    pm.getApplicationLabel(app).toString()
                                } catch (_: Exception) {
                                    pkg
                                }
                                val isSystem = (app.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                                list.add(mapOf(
                                    "packageName" to pkg,
                                    "name" to name,
                                    "isSystem" to isSystem,
                                    "flags" to app.flags
                                ))
                            }
                            runOnUiThread {
                                result.success(list)
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("GET_APPS_FAILED", e.message, null)
                            }
                        }
                    }.start()
                }
                "getAppIcon" -> {
                    val pkg = call.argument<String>("packageName")
                    if (pkg != null) {
                        Thread {
                            try {
                                val pm = packageManager
                                val iconDrawable = pm.getApplicationIcon(pkg)
                                val bitmap = if (iconDrawable is BitmapDrawable) {
                                    iconDrawable.bitmap
                                } else {
                                    val bmp = Bitmap.createBitmap(
                                        iconDrawable.intrinsicWidth.coerceAtLeast(1),
                                        iconDrawable.intrinsicHeight.coerceAtLeast(1),
                                        Bitmap.Config.ARGB_8888
                                    )
                                    val canvas = Canvas(bmp)
                                    iconDrawable.setBounds(0, 0, canvas.width, canvas.height)
                                    iconDrawable.draw(canvas)
                                    bmp
                                }
                                val stream = ByteArrayOutputStream()
                                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                                val bytes = stream.toByteArray()
                                runOnUiThread {
                                    result.success(bytes)
                                }
                            } catch (_: Exception) {
                                runOnUiThread {
                                    result.success(null)
                                }
                            }
                        }.start()
                    } else {
                        result.success(null)
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
                    val content = call.argument<String>("notificationContent")
                    val disconnect = call.argument<String>("notificationDisconnect")
                    val perAppEnable = call.argument<Boolean>("perAppEnable") ?: false
                    val perAppWhitelist = call.argument<Boolean>("perAppWhitelist") ?: false
                    val perAppPackages = call.argument<List<String>>("perAppPackages") ?: emptyList()

                    val intent = Intent(this, WmimoVpnService::class.java).apply {
                        action = WmimoVpnService.ACTION_START
                        putExtra("mixedPort", mixedPort)
                        if (content != null) putExtra("notificationContent", content)
                        if (disconnect != null) putExtra("notificationDisconnect", disconnect)
                        putExtra("perAppEnable", perAppEnable)
                        putExtra("perAppWhitelist", perAppWhitelist)
                        putStringArrayListExtra("perAppPackages", ArrayList(perAppPackages))
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "updateNotification" -> {
                    val content = call.argument<String>("notificationContent")
                    val disconnect = call.argument<String>("notificationDisconnect")
                    val intent = Intent(this, WmimoVpnService::class.java).apply {
                        action = WmimoVpnService.ACTION_UPDATE
                        if (content != null) putExtra("notificationContent", content)
                        if (disconnect != null) putExtra("notificationDisconnect", disconnect)
                    }
                    if (WmimoVpnService.isServiceRunning) {
                        startService(intent)
                    }
                    result.success(true)
                }
                "setAppLocale" -> {
                    val tag = call.argument<String>("languageTag") ?: "zh-CN"
                    try {
                        val locale = Locale.forLanguageTag(tag)
                        Locale.setDefault(locale)
                        val config = resources.configuration
                        config.setLocale(locale)
                        resources.updateConfiguration(config, resources.displayMetrics)
                        applicationContext.resources.updateConfiguration(config, applicationContext.resources.displayMetrics)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            val localeManager = getSystemService(LocaleManager::class.java)
                            localeManager?.applicationLocales = LocaleList.forLanguageTags(tag)
                        }
                    } catch (_: Exception) {}
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
