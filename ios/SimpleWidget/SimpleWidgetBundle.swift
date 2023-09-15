//
//  SimpleWidgetBundle.swift
//  SimpleWidget
//
//  Created by Shawn on 2023-08-15.
//

import WidgetKit
import SwiftUI

@main
struct SimpleWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleWidget()
        SimpleWidgetLiveActivity()
    }
}
