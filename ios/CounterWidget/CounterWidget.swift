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
        var themeColor:Color?;
        let colorString = userDefaults?.string(forKey: "themeColor")
        // Split colorsString into a list of Doubles, if all goes well create a Color
        let colors = colorString?.components(separatedBy: ",").compactMap {Double($0)}
        if(colors != nil && colors?.count == 3){
            themeColor = Color(red: colors![0], green: colors![1], blue: colors![2])
        }
        completion(CounterEntry(
            date: Date(),
            count: count,
            themeColor: themeColor,
            bgImgPath: bgImgPath
        )
        )
    }
    
    // Provide an array of entries for the current time and, optionally, any future times
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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


// Defines the view / layout of the widget
struct CounterWidgetView : View {
    var entry: Provider.Entry
    
    // Use some funky syntax to get the current widgetFamily
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    // Implement init() so we can register a font included in Flutter Asset Bundle
    init(entry: Provider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(flutterAssetBundle.appending(
            path: fontPath) as CFURL,
                                         CTFontManagerScope.process,
                                         nil)
    }
    
    var body: some View {
        // If we don't have a background image path, assume the app has not been launched yet
        let hasAppRunOnce = false && entry.bgImgPath != nil;
        // Get the path of the rendered image, or fallback to a default image
        let imgPath = //entry.bgImgPath ??
        flutterAssetBundle.appending(path: defaultBgImagePath).path();
        
        if let uiImage = UIImage(contentsOfFile: imgPath) {
            return AnyView(
                ZStack{
                    // Use the themeColor from the flutter app or a default grey
                    entry.themeColor ?? Color(red: 0.2, green: 0.2, blue: 0.2)
                    // The rendered widget or the default background image
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    // Top bar, only show for med/large
                    if(family != WidgetFamily.systemSmall){
                        HStack {
                            FlutterLogo()
                            Spacer()
                            FlutterLogo()
                            Text("Test!")
                        }.padding()
                    }
                    // If the app has never been launched we won't have a rendered background image.
                    // Instead of the count, show a warning message
                    if(hasAppRunOnce == false){
                        Text("Launch Home Widget app to update this widget")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .font(.system(size: family == .systemSmall ? 12 : 20))
                            .padding(.horizontal, family == .systemSmall ? 10 : 40)
                    } 
                    // Show the count
                    else {
                        Text("\(entry.count)")
                            .foregroundStyle(.white)
                            // Use the custom font from Flutter
                            .font(Font.custom(fontName, size: family == .systemSmall ? 48 : 72));
                    }
                }.widgetBackground(Color.clear)
            )
        }
        return AnyView(Text("Something went wrong..."))
        
    }
}

/// Custom view for displaying a flutter logo asset from in the Flutter asset bundle
struct FlutterLogo : View {
    var body: some View {
        let image = bundle.appending(path: "/assets/images/flutter-logo-white.svg").path();
        if let uiImage = UIImage(contentsOfFile: image) {
            let image = Image(uiImage: uiImage)
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
            return AnyView(image)
        }
        print("The image file could not be loaded")
        return AnyView(EmptyView())
    }

}

// Workaround for new APIs added in iOS17 that required containerBackground to be set.
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, iOS 17.0, macOSApplicationExtension 14.0, *) {
            // Widget will show errors if this isn't implemented on iOS 17
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

// Utility method for loading flutter assets from the assetBundle
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
