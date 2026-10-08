import WidgetKit
import SwiftUI

struct WmimoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WmimoWidgetEntry {
        WmimoWidgetEntry(date: Date(), isConnected: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (WmimoWidgetEntry) -> ()) {
        let entry = WmimoWidgetEntry(date: Date(), isConnected: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WmimoWidgetEntry>) -> ()) {
        let entry = WmimoWidgetEntry(date: Date(), isConnected: false)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WmimoWidgetEntry: TimelineEntry {
    let date: Date
    let isConnected: Bool
}

struct WmimoWidgetEntryView : View {
    var entry: WmimoWidgetProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: entry.isConnected ? "shield.fill" : "shield")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(entry.isConnected ? .green : .gray)
            Text("Wmimo")
                .font(.system(size: 14, weight: .bold))
            Text(entry.isConnected ? "Connected" : "Disconnected")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct wmimoWidget: Widget {
    let kind: String = "com.wmimo.app.wmimoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WmimoWidgetProvider()) { entry in
            WmimoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Wmimo Status")
        .description("Quickly view Wmimo proxy connection status.")
        .supportedFamilies([.systemSmall])
    }
}
