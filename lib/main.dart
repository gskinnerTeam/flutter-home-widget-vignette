import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_widget_vignette/home_widget_bg_image.dart';
import 'package:flutter_home_widget_vignette/home_widget_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Start the counter at a >1 value for nicer bg visualizations
  static const _defaultCounterValue = 3;
  static const _countPrefsKey = 'count';

  // Use SharedPreferences to persist the current count between app launches so it stays in sync with the last rendered background
  SharedPreferences? _prefs;
  final _counter = ValueNotifier(_defaultCounterValue);
  final _homeWidgetController = CounterHomeWidgetController();

  @override
  void initState() {
    _homeWidgetController.init();
    // Get userPrefs, start counter at last saved value (if any)
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _counter.value = _prefs?.getInt(_countPrefsKey) ?? _counter.value;
    });
    // Listen for changes on counter,
    _counter.addListener(() {
      _prefs?.setInt(_countPrefsKey, _counter.value); // Save current count to UserPrefs
      // Update the HomeWidget with the new count, rendering a new background image
      _homeWidgetController.setCountAndRender(count: _counter.value);
      setState(() {}); // Rebuild
    });
    super.initState();
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _incrementCounter() => _counter.value = _counter.value + 1;

  void _resetCount() => _counter.value = _defaultCounterValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pass current themeColor for the HomeWidget
    _homeWidgetController.setColor(Theme
        .of(context)
        .primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background, wrapped in AnimatedSwitcher for a nice effect
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: HomeWidgetBgImage(
              key: ValueKey(_counter),
              count: _counter.value,
              size: const Size(400, 400),
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),

          // Reset btn
          _buildResetBtnForStack(),

          // Counter widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_counter',
                  style: TextStyle(
                    fontSize: 48,
                    fontFamily: 'RubikGlitch',
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResetBtnForStack() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextButton(
            onPressed: _resetCount,
            child: const Text('RESET COUNT'),
          ),
        ),
      ),
    );
  }
}
