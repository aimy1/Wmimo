import WidgetKit
import SwiftUI

@main
struct wmimoWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 18.0, *) {
            wmimoWidgetControl()
        }
        wmimoWidget()
    }
}
