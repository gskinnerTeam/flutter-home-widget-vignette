//
//  FlutterUtils.swift
//  Runner
//
//  Created by Shawn on 2023-10-17.
//

import Foundation

var bundle: URL {
   let bundle = Bundle.main
   if bundle.bundleURL.pathExtension == "appex" {
       // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
       var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
       if #available(iOS 16.0, *) {
           url.append(component: "Frameworks/App.framework/flutter_assets")
       } 
       return url
   }
   return bundle.bundleURL
}
