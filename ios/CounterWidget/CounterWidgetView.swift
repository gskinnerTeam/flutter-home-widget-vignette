import Foundation
import SwiftUI
import WidgetKit

// Defines the view / layout of the widget
struct CounterWidgetView : View {
    var entry: Provider.Entry
    
    // Use some funky syntax to get the current widgetFamily
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    // Implement init() so we can register a font included in Flutter Asset Bundle
    init(entry: Provider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(flutterAssetBundle.appending(
            path: fontPath) as CFURL, CTFontManagerScope.process, nil)
    }
    
    var body: some View {
        // If we don't have a background image path, assume the app has not been launched yet
        let hasAppRunOnce = entry.bgImgPath != nil;
        
        // Get the path of the rendered image, or fallback to a default image
        let imgPath = entry.bgImgPath ??
        flutterAssetBundle.appending(path: defaultBgImagePath).path();
        
        // Use the themeColor from the flutter app or a default grey
        let bgColor = entry.themeColor ?? Color(red: 0.2, green: 0.2, blue: 0.2);
        
        if let uiImage = UIImage(contentsOfFile: imgPath) {
            return AnyView(
                ZStack{
                    // The rendered widget or the default background image
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    // If the app has never been launched we won't have a rendered background image.
                    // Instead of the count, show a warning message
                    if(hasAppRunOnce == false){
                        Text("Launch the App to update this Widget!")
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
                }.widgetBackground(bgColor)
            )
        }
        return AnyView(Text("Something went wrong..."))
        
    }
}

// Workaround for new APIs added in iOS17 that required `containerBackground` to be set.
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
