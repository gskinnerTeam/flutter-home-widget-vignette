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
let bgRenderKey = "bgRender";

struct Provider: TimelineProvider {
    // Provide an entry for a placeholder version of the widget
    func placeholder(in context: Context) -> CounterEntry {
        CounterEntry(count: 0, date: Date(), displaySize: context.displaySize)
    }
    
    // Provide an entry for the current time and state of the widget
    func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: groupId)
        let count = userDefaults?.integer(forKey: counterId) ?? 2;
        
        func getEntry(_ count:Int,_  context: Context,_ imgPath:String?) -> CounterEntry{
            return CounterEntry(
                count: count,
                date: Date(),
                displaySize: context.displaySize,
                bgImgPath: imgPath)
        }
        var entry:CounterEntry?
//        if(context.family == .systemSmall){
//            let bgImgPath = userDefaults?.string(forKey: "\(bgRenderKey)_sm")
//            entry = getEntry(count, context, bgImgPath)
//        } 
//        else if(context.family == .systemMedium){
//            let bgImgPath = userDefaults?.string(forKey: "\(bgRenderKey)_md")
//            entry = getEntry(count, context, bgImgPath)
//        }
//        else if(context.family == .systemLarge){
//            let bgImgPath = userDefaults?.string(forKey: "\(bgRenderKey)_lg")
//            entry = getEntry(count, context, bgImgPath)
//        } else {
            let bgImgPath = userDefaults?.string(forKey: bgRenderKey)
            entry = getEntry(count, context, bgImgPath)
//        }
        
        completion(entry!);
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
    let count: Int
    let date: Date
    let displaySize: CGSize
    var bgImgPath: String? = nil

//    let imageData: Data?
}

// Widget, defines the display name and description, and also wraps the View
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


// Defines the view / layout of the widget
struct CounterWidgetView : View {
    var entry: Provider.Entry
    
    var body: some View {
        let imgPath = entry.bgImgPath ?? flutterAssetBundle.appending(path: "/assets/images/widget-background-empty.png").path();
        
            if let uiImage = UIImage(contentsOfFile: imgPath) {
                let img = Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .edgesIgnoringSafeArea(.all)
                    //.frame(width: entry.displaySize.width, height: 400)
                return AnyView(
                    ZStack{
                        Color.gray
                        img
//                        LinearGradient(
//                            gradient: Gradient(colors: [.black.opacity(0), .black]),
//                            startPoint: .center,
//                            endPoint: .bottom)
                        VStack{
                            Text("\(entry.count)").font(.system(size: 72));
                        }.padding()
                    }
                )
                
            }
        return AnyView(EmptyView())
        
    }
}

// Disable system margins with new iOS17 APIs if available
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, iOS 17.0, macOSApplicationExtension 14.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

var flutterAssetBundle: URL {
    let bundle = Bundle.main
    if bundle.bundleURL.pathExtension == "appex" {
        // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
        var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
        url.append(component: "Frameworks/App.framework/flutter_assets")
        return url
    }
    return bundle.bundleURL
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
