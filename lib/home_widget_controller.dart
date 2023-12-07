import 'package:flutter/material.dart';
import 'package:flutter_home_widget_vignette/home_widget_bg_image.dart';
import 'package:home_widget/home_widget.dart';

class CounterHomeWidgetController {
  // Matches the `kind` specified when creating the `WidgetConfiguration` in the swift code
  final String widgetKind = 'CounterWidget';

  // UserDefaults keys, matches values declared in swiftUi
  final String groupId = 'group.com.gskinner.counterwidget';
  final String counterId = 'counter';
  final String bgColorId = 'bgColor';

  // Used in the `HomeWidget.renderFlutterWidget` method
  final String bgRenderKey = 'bgRender';
  final String bgColorKey = 'bgColor';

  void init() {
    HomeWidget.setAppGroupId(groupId);
  }

  Future<void> setBgColor(Color value) async {
    debugPrint('Update HomeWidget bgColor = $value');
    HomeWidget.saveWidgetData<Color>(bgColorKey, value);
    HomeWidget.updateWidget(iOSName: widgetKind);
  }

  Future<void> setCount({required int count}) async {
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

    // Inform the widget we have updated something
    HomeWidget.updateWidget(iOSName: widgetKind);
  }
}
