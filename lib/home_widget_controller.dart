import 'package:flutter_home_widget_vignette/home_widget_bg_image.dart';
import 'package:home_widget/home_widget.dart';

class CounterHomeWidgetController {
  // Matches the `kind` specified when creating the `WidgetConfiguration` in the swift code
  final String widgetKind = 'CounterWidget';
  // UserDefaults keys, matches values declared in swiftUi
  final String userDefaultsGroupId = 'group.com.gskinner.counterwidget';
  final String userDefaultsCounterId = 'counter';
  // Used in the `HomeWidget.renderFlutterWidget` method
  final String bgRenderKey = 'bgRender';

  void init() => HomeWidget.setAppGroupId(userDefaultsGroupId);

  Future<void> update(int counterValue) async {
      // Save current _counter value to UserDefaults
      await HomeWidget.saveWidgetData<int>(userDefaultsCounterId, counterValue);

      // Render image background
      await HomeWidget.renderFlutterWidget(HomeWidgetBgImage(count: counterValue), key: bgRenderKey);

      // Inform the widget we have updated something
      HomeWidget.updateWidget(iOSName: widgetKind);
  }
}