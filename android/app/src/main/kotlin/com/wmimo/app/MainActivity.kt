package com.wmimo.app

import android.Manifest
import android.app.LocaleManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.net.VpnService
import android.os.Build
import android.os.Handler
import android.os.LocaleList
import android.os.Looper
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
    private val APP_LIST_REQUEST_CODE = 1003

    private var pendingVpnResult: MethodChannel.Result? = null
    private var pendingNotifResult: MethodChannel.Result? = null
    private var pendingAppListResult: MethodChannel.Result? = null

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
                "openAppSettings" -> {
                    var opened = false
                    // 1. First attempt: MIUI / HyperOS PermissionsEditorActivity (where "获取应用列表" resides)
                    try {
                        val miuiIntent = Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                            setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
                            putExtra("extra_pkgname", packageName)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(miuiIntent)
                        opened = true
                    } catch (_: Throwable) {
                        try {
                            val miuiIntent2 = Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                                setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.AppPermissionsEditorActivity")
                                putExtra("extra_pkgname", packageName)
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(miuiIntent2)
                            opened = true
                        } catch (_: Throwable) {
                            try {
                                val miuiIntent3 = Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                                    putExtra("extra_pkgname", packageName)
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }
                                startActivity(miuiIntent3)
                                opened = true
                            } catch (_: Throwable) {}
                        }
                    }

                    // 2. Fallback: Standard Android Application Details Settings
                    if (!opened) {
                        try {
                            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                                data = Uri.fromParts("package", packageName, null)
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(intent)
                            opened = true
                        } catch (_: Throwable) {
                            try {
                                val fallbackIntent = Intent(Settings.ACTION_SETTINGS).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }
                                startActivity(fallbackIntent)
                                opened = true
                            } catch (_: Throwable) {}
                        }
                    }
                    result.success(opened)
                }
                "hasAppListPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        try {
                            val granted = ContextCompat.checkSelfPermission(
                                this,
                                "com.android.permission.GET_INSTALLED_APPS"
                            ) == PackageManager.PERMISSION_GRANTED
                            result.success(granted)
                        } catch (_: Throwable) {
                            result.success(true)
                        }
                    } else {
                        result.success(true)
                    }
                }
                "requestAppListPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        try {
                            val permInfo = try {
                                packageManager.getPermissionInfo("com.android.permission.GET_INSTALLED_APPS", 0)
                            } catch (_: Throwable) {
                                null
                            }

                            if (permInfo != null) {
                                pendingAppListResult = result
                                ActivityCompat.requestPermissions(
                                    this,
                                    arrayOf("com.android.permission.GET_INSTALLED_APPS"),
                                    APP_LIST_REQUEST_CODE
                                )
                                // Safety watchdog: release within 2.5s if OS suppresses dialog
                                Handler(Looper.getMainLooper()).postDelayed({
                                    if (pendingAppListResult != null) {
                                        try {
                                            pendingAppListResult?.success(false)
                                        } catch (_: Throwable) {}
                                        pendingAppListResult = null
                                    }
                                }, 2500)
                            } else {
                                result.success(false)
                            }
                        } catch (_: Throwable) {
                            result.success(false)
                        }
                    } else {
                        result.success(true)
                    }
                }
                "getInstalledAppList" -> {
                    val mainHandler = Handler(Looper.getMainLooper())
                    val list = ArrayList<Map<String, Any>>()
                    val seenPackages = HashSet<String>()
                    val pm = packageManager
                    val responded = java.util.concurrent.atomic.AtomicBoolean(false)

                    val watchdog = Runnable {
                        if (responded.compareAndSet(false, true)) {
                            try {
                                result.success(list)
                            } catch (_: Throwable) {}
                        }
                    }
                    mainHandler.postDelayed(watchdog, 2500)

                    Thread {
                        try {
                            // Method 1: Direct getInstalledApplications (fastest, 1 IPC call, <20ms)
                            var allApps: List<ApplicationInfo> = try {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                    pm.getInstalledApplications(PackageManager.ApplicationInfoFlags.of(0))
                                } else {
                                    @Suppress("DEPRECATION")
                                    pm.getInstalledApplications(0)
                                }
                            } catch (_: Throwable) {
                                emptyList()
                            }

                            if (allApps.isEmpty()) {
                                try {
                                    allApps = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                        pm.getInstalledApplications(PackageManager.ApplicationInfoFlags.of(PackageManager.MATCH_ALL.toLong()))
                                    } else {
                                        @Suppress("DEPRECATION")
                                        pm.getInstalledApplications(PackageManager.MATCH_ALL)
                                    }
                                } catch (_: Throwable) {}
                            }

                            for (app in allApps) {
                                val pkg = app.packageName ?: continue
                                if (pkg == packageName || seenPackages.contains(pkg)) continue
                                seenPackages.add(pkg)

                                val isSystem = (app.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                                val label = try {
                                    app.loadLabel(pm).toString()
                                } catch (_: Throwable) {
                                    app.nonLocalizedLabel?.toString() ?: pkg
                                }

                                list.add(mapOf(
                                    "packageName" to pkg,
                                    "name" to label,
                                    "isSystem" to isSystem,
                                    "flags" to app.flags
                                ))
                            }

                            // Method 2: If getInstalledApplications returned nothing (restricted by OEM), query launcher activities
                            if (list.isEmpty()) {
                                try {
                                    val launcherIntent = Intent(Intent.ACTION_MAIN).apply {
                                        addCategory(Intent.CATEGORY_LAUNCHER)
                                    }
                                    var launcherApps: List<ResolveInfo> = try {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                            pm.queryIntentActivities(launcherIntent, PackageManager.ResolveInfoFlags.of(0))
                                        } else {
                                            @Suppress("DEPRECATION")
                                            pm.queryIntentActivities(launcherIntent, 0)
                                        }
                                    } catch (_: Throwable) {
                                        emptyList()
                                    }

                                    if (launcherApps.isEmpty()) {
                                        try {
                                            launcherApps = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                                pm.queryIntentActivities(launcherIntent, PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_ALL.toLong()))
                                            } else {
                                                @Suppress("DEPRECATION")
                                                pm.queryIntentActivities(launcherIntent, PackageManager.MATCH_ALL)
                                            }
                                        } catch (_: Throwable) {}
                                    }

                                    for (resolveInfo in launcherApps) {
                                        val actInfo = resolveInfo.activityInfo ?: continue
                                        val pkg = actInfo.packageName ?: continue
                                        if (pkg == packageName || seenPackages.contains(pkg)) continue
                                        seenPackages.add(pkg)

                                        val label = try {
                                            resolveInfo.loadLabel(pm)?.toString() ?: actInfo.loadLabel(pm)?.toString() ?: pkg
                                        } catch (_: Throwable) {
                                            pkg
                                        }
                                        val appFlags = actInfo.applicationInfo?.flags ?: 0
                                        val isSystem = (appFlags and ApplicationInfo.FLAG_SYSTEM) != 0

                                        list.add(mapOf(
                                            "packageName" to pkg,
                                            "name" to label,
                                            "isSystem" to isSystem,
                                            "flags" to appFlags
                                        ))
                                    }
                                } catch (_: Throwable) {}
                            }

                            // Method 3: Final fallback to getInstalledPackages
                            if (list.isEmpty()) {
                                try {
                                    var packages: List<PackageInfo> = try {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                            pm.getInstalledPackages(PackageManager.PackageInfoFlags.of(0))
                                        } else {
                                            @Suppress("DEPRECATION")
                                            pm.getInstalledPackages(0)
                                        }
                                    } catch (_: Throwable) {
                                        emptyList()
                                    }

                                    if (packages.isEmpty()) {
                                        try {
                                            packages = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                                pm.getInstalledPackages(PackageManager.PackageInfoFlags.of(PackageManager.MATCH_ALL.toLong()))
                                            } else {
                                                @Suppress("DEPRECATION")
                                                pm.getInstalledPackages(PackageManager.MATCH_ALL)
                                            }
                                        } catch (_: Throwable) {}
                                    }

                                    for (p in packages) {
                                        val pkg = p.packageName ?: continue
                                        if (pkg == packageName || seenPackages.contains(pkg)) continue
                                        seenPackages.add(pkg)

                                        val appInfo = p.applicationInfo
                                        val isSystem = if (appInfo != null) (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0 else false
                                        val appFlags = appInfo?.flags ?: (if (isSystem) 1 else 0)
                                        val label = try {
                                            appInfo?.loadLabel(pm)?.toString() ?: pkg
                                        } catch (_: Throwable) {
                                            appInfo?.nonLocalizedLabel?.toString() ?: pkg
                                        }

                                        list.add(mapOf(
                                            "packageName" to pkg,
                                            "name" to label,
                                            "isSystem" to isSystem,
                                            "flags" to appFlags
                                        ))
                                    }
                                } catch (_: Throwable) {}
                            }
                        } catch (_: Throwable) {}

                        mainHandler.removeCallbacks(watchdog)
                        if (responded.compareAndSet(false, true)) {
                            mainHandler.post {
                                try {
                                    result.success(list)
                                } catch (_: Throwable) {}
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
                                    try {
                                        result.success(bytes)
                                    } catch (_: Throwable) {
                                        result.success(null)
                                    }
                                }
                            } catch (_: Throwable) {
                                runOnUiThread {
                                    try {
                                        result.success(null)
                                    } catch (_: Throwable) {}
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
        } else if (requestCode == APP_LIST_REQUEST_CODE) {
            val isGranted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingAppListResult?.success(isGranted)
            pendingAppListResult = null
        }
    }

    override fun onDestroy() {
        pendingVpnResult = null
        pendingNotifResult = null
        pendingAppListResult = null
        super.onDestroy()
    }
}
