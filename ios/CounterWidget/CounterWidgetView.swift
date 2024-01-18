import Foundation
import SwiftUI
import WidgetKit


// Flutter assets
let defaultBgAssetUrl = getflutterAssetUrl("/assets/images/default-bg.png");
let fontAssetUrl = getflutterAssetUrl("/assets/fonts/RubikGlitch-Regular.ttf")

let fontName = "Rubik Glitch"

// Defines the view / layout of the widget
struct CounterWidgetView : View {
    var entry: Provider.Entry
    
    // Get the current widgetFamily, so we can tweak the view layout if we're small, medium or large
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    // Implement init() so we can register a font included in Flutter Asset Bundle
    init(entry: Provider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(fontAssetUrl as CFURL, CTFontManagerScope.process, nil)
    }
    
    var body: some View {
        // If we don't have a background image path, assume the app has not been launched yet
        let hasAppRunOnce = entry.bgImgUrl != nil;
        // Get the path of the rendered image, or fallback to a default image
        let imgPath = entry.bgImgUrl ?? defaultBgAssetUrl.path();
        
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
func getflutterAssetUrl(_ path: String) -> URL {
    let url = Bundle.main.bundleURL
    if url.pathExtension == "appex" {
        // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
        var url = url.deletingLastPathComponent().deletingLastPathComponent()
        url.append(component: "Frameworks/App.framework/flutter_assets")
    }
    return url.appending(path: path)
}
