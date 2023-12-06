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
let userDefaultsGroupId = "group.com.gskinner.counterwidget";
let userDefaultsCounterId = "counter";

struct Provider: TimelineProvider {
    // Provide an entry for a placeholder version of the widget
    func placeholder(in context: Context) -> CounterEntry {
        CounterEntry(date: Date(), count: 0)
    }
    
    // Provide an entry for the current time and state of the widget
    func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> ()) {
        let entry:CounterEntry
        if(context.isPreview){
            entry = CounterEntry(date: Date(), count: 0)
        } else {
            let userDefaults = UserDefaults(suiteName: userDefaultsGroupId)
            let count = userDefaults?.integer(forKey: userDefaultsCounterId) ?? 0;
            entry = CounterEntry(date: Date(), count: count)
        }
        completion(entry);
    }
    
    // Provide an array of entries for the current time and, optionally, any future times
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

/// Entry, is passed into the view and defines the data it needs
struct CounterEntry : TimelineEntry {
    let date: Date
    let count:Int;
//    let displaySize: CGSize
//    let imageData: Data?
}

// Widget, defines the display name and description, and also wraps the View
struct CounterWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: widgetKind, provider: Provider()) { entry in
            CounterWidgetView(entry: entry)
        }
        .configurationDisplayName("Counter Widget")
        .description("Displays the current count of the counter app.")
    }
}


// Defines the view / layout of the widget
struct CounterWidgetView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0), .black]),
                startPoint: .center,
                endPoint: .bottom)
            VStack{
                Text("\(entry.count)");
            }.padding()
        }
    }
}



//// Load an image from the flutter assets bundle
//struct LogoImage : View {
//    var entry: CounterEntry
//    var body: some View {
//        let image = bundle.appending(path: "/assets/logo.png").path();
//        print(image)
//        if let uiImage = UIImage(contentsOfFile: image) {
//            let width = entry.displaySize.height*0.5
//            let image = Image(uiImage: uiImage)
//                .resizable()
//                .frame(width: width, height: width/3.45, alignment: .center)
//            return AnyView(image)
//        }
//        print("The image file could not be loaded")
//        return AnyView(EmptyView())
//    }
//    
//}
//
//// Display a previously loaded remote image
//struct NetImage : View {
//    var imageData: Data?
//    var body: some View {
//        if imageData != nil, let uiImage = UIImage(data: imageData!) {
//            return Image(uiImage: uiImage)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 80, height: 26.0)
//        } else {
//            return Image("EmptyChart")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 80, height: 26.0)
//        }
//    }
//}
