//
//  PriorityWidget.swift
//  PriorityWidget
//
//  Created by Alex on 4/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), progress: 0.6)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), progress: 0.7)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), progress: 0.7)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let progress: Double // from 0.0 to 1.0
}


struct PriorityWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ProgressRingView(progress: 0.75/*entry.progress*/)
                .padding(8)
        }
    }
}

struct PriorityWidget: Widget {
    let kind: String = "PriorityWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PriorityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Progress Ring")
        .description("Shows your to-do progress.")
        .supportedFamilies([.systemSmall])  
    }
}

#Preview(as: .systemSmall) {
    PriorityWidget()
} timeline: {
    SimpleEntry(date: .now, progress: 0.8)
}
