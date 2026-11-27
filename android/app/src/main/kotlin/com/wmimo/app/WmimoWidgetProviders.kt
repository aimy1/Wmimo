package com.wmimo.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent

abstract class BaseWmimoWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        WmimoWidgetUpdater.refreshAllWidgets(context)
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        WmimoWidgetUpdater.refreshAllWidgets(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val action = intent.action ?: return
        if (action == WmimoWidgetUpdater.ACTION_WIDGET_REFRESH ||
            action == WmimoWidgetUpdater.ACTION_WIDGET_TOGGLE_VPN ||
            action == WmimoWidgetUpdater.ACTION_WIDGET_CYCLE_MODE ||
            action == WmimoWidgetUpdater.ACTION_WIDGET_SET_MODE ||
            action == WmimoWidgetUpdater.ACTION_WIDGET_SWITCH_NODE
        ) {
            val pendingResult = goAsync()
            WmimoWidgetUpdater.handleBroadcastActionAsync(context, intent, pendingResult)
        }
    }
}

class WmimoStatusWidgetProvider : BaseWmimoWidgetProvider()

class WmimoTrafficWidgetProvider : BaseWmimoWidgetProvider()

class WmimoQuickSwitchWidgetProvider : BaseWmimoWidgetProvider()
