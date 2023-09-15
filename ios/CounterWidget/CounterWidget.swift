//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Shawn on 2023-09-11.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CounterEntry {
        CounterEntry(date: Date(), count: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> ()) {
        let entry:CounterEntry
        if(context.isPreview){
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.com.gskinner.homewidget")
            let count = userDefaults?.integer(forKey: "counter") ?? 0;
            entry = CounterEntry(date: Date(), count: count)
        }
        completion(entry);
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}


struct CounterEntry : TimelineEntry {
    let date: Date
    let count:Int;
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack{
            Text("\(entry.count)")	
        }.padding()
        //Text("Hello World")
    }
}

struct CounterWidget: Widget {
    let kind: String = "CounterWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Counter Widget")
        .description("Displays the current count of the counter app.")
    }
}
