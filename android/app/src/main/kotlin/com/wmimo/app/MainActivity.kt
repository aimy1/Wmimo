package com.wmimo.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.wmimo.app/native_helper").setMethodCallHandler { call, result ->
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
                else -> result.notImplemented()
            }
        }
    }
}
