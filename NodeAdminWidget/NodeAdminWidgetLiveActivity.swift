//
//  NodeAdminWidgetLiveActivity.swift
//  NodeAdminWidget
//
//  Created by Jean Demeusy on 2/18/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NodeAdminWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NodeAdminWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NodeAdminWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NodeAdminWidgetAttributes {
    fileprivate static var preview: NodeAdminWidgetAttributes {
        NodeAdminWidgetAttributes(name: "World")
    }
}

extension NodeAdminWidgetAttributes.ContentState {
    fileprivate static var smiley: NodeAdminWidgetAttributes.ContentState {
        NodeAdminWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NodeAdminWidgetAttributes.ContentState {
         NodeAdminWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NodeAdminWidgetAttributes.preview) {
   NodeAdminWidgetLiveActivity()
} contentStates: {
    NodeAdminWidgetAttributes.ContentState.smiley
    NodeAdminWidgetAttributes.ContentState.starEyes
}
