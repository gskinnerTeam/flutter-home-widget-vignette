import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_home_widget_vignette/home_widget_bg_image.dart';
import 'package:home_widget/home_widget.dart';

class CounterHomeWidgetController {
  // Must match the `kind` specified when creating the `WidgetConfiguration` in swiftUi
  final String widgetKind = 'CounterWidget';

  // UserDefaults keys, must match values declared in swiftUi
  final String groupId = 'group.com.gskinner.counterwidget';
  final String counterId = 'counter';
  final String themeColorId = 'themeColor';
  final String bgColorId = 'bgColor';

  // Used in the `HomeWidget.renderFlutterWidget` method
  final String bgRenderKey = 'bgRender';

  void init() {
    // Set groupId so we can share data with the HomeWidget
    HomeWidget.setAppGroupId(groupId);
  }

  Future<void> setColor(Color value) async {
    // Save value to UserDefaults as a comma separated string of 0-1 values
    final colorString = [value.red / 255, value.green / 255, value.blue / 255].join(',');
    await HomeWidget.saveWidgetData<String>(themeColorId, colorString);
    // Inform the widget we have changed something
    HomeWidget.updateWidget(iOSName: widgetKind);
  }

  // Updates the shared count value and renders a new background
  Future<void> setCountAndRender({required int count}) async {
    debugPrint('Update HomeWidget count = $count');
    // Save current _counter value to UserDefaults
    await HomeWidget.saveWidgetData<int>(counterId, count);

    // Render image background
    const size = Size(600, 600);
    await HomeWidget.renderFlutterWidget(
      HomeWidgetBgImage(count: count, size: size),
      logicalSize: size,
      key: bgRenderKey,
    );

    // Inform the widget we have changed something
    HomeWidget.updateWidget(iOSName: widgetKind);
  }
}
