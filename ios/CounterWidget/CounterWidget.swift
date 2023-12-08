//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Shawn on 2023-09-11.
//

import WidgetKit
import SwiftUI
import Intents

// Used in Flutter for the `HomeWidget.updateWidget` method
let widgetKind = "CounterWidget";

// UserDefaults keys, matches values declared in Flutter
let groupId = "group.com.gskinner.counterwidget";
let counterId = "counter";
let themeColorId = "themeColor";
let bgRenderKey = "bgRender";

// Flutter assets
let defaultBgImagePath = "/assets/images/default-bg.png";
let fontPath = "/assets/fonts/RubikGlitch-Regular.ttf"
let fontName = "Rubik Glitch"

// A `TimelineProvider` advises iOS when it should next update the widget
// and returns an `Entry` for the widget in different contexts.
// UserDefaults info is loaded inside the getSnapshot method.
struct Provider: TimelineProvider {
    // Provide an entry for a placeholder version of the widget
    func placeholder(in context: Context) -> CounterEntry {
        CounterEntry(date: Date(), count: 0)
    }
    
    // Provide an entry for the current time and state of the widget
    func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> ()) {
        // Load shared data from Flutter app, and pass it into the Entry
        let userDefaults = UserDefaults(suiteName: groupId)
        let count = userDefaults?.integer(forKey: counterId) ?? 3
        let bgImgPath = userDefaults?.string(forKey: bgRenderKey)
        
        // The themeColor is saved as a comma-seperated list of numbers
        // Split colorsString into a list of Doubles, if all goes well create a Color
        var themeColor:Color?;
        let colorString = userDefaults?.string(forKey: themeColorId)
        let colors = colorString?.components(separatedBy: ",").compactMap {Double($0)}
        if(colors != nil && colors?.count == 3){
            themeColor = Color(red: colors![0], green: colors![1], blue: colors![2])
        }
        
        completion(
            CounterEntry(
                date: Date(),
                count: count,
                themeColor: themeColor,
                bgImgPath: bgImgPath
            )
        )
    }
    
    // Provide an array of entries for the current time and, optionally, any future times
    func getTimeline(in context: Context, completion: @escaping (Timeline<CounterEntry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            // Update us any time after the current entry time
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

// TimelineEntry, created by the TimelineProvider and passed into the eventual View,
// Defines any external data it needs and a required date value
struct CounterEntry : TimelineEntry {
    let date: Date
    let count: Int
    var themeColor: Color? = nil
    var bgImgPath: String? = nil
}

// Widget defines the widget configuration and which View will render the entry
struct CounterWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: widgetKind, provider: Provider()) { entry in
            CounterWidgetView(entry: entry)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Counter Widget")
        .description("Displays the current count of the counter app.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

