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
  static const _defaultCounterValue = 3;
  static const _countPrefsKey = 'count';

  // Start the counter at a >1 value for nicer bg visualizations
  int _counter = _defaultCounterValue;

  final _homeWidgetController = CounterHomeWidgetController();

  // Use prefs to persist the current count between app launches
  SharedPreferences? _prefs;

  @override
  void initState() {
    _initPrefs();
    _homeWidgetController.init();
    super.initState();
  }

  // Get UserPrefs instance and load initial value for _counter
  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _prefs?.getInt(_countPrefsKey) ?? _counter;
      _handleCounterChanged();
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _handleCounterChanged();
  }

  void _resetCount() {
    setState(() {
      _counter = _defaultCounterValue;
    });
    _handleCounterChanged();
  }

  // Save current count to userPrefs and update the HomeWidget
  void _handleCounterChanged() {
    _prefs?.setInt(_countPrefsKey, _counter);
    _homeWidgetController.setCount(count: _counter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pass current themeColor for the HomeWidget
    _homeWidgetController.setColor(Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background, wrapped in AnimatedSwitcher for a nice effect
          HomeWidgetBgImage(
            count: _counter,
            size: const Size(400, 400),
            color: Theme.of(context).primaryColor,
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
                  style: TextStyle(fontSize: 48, fontFamily: 'RubikGlitch', color: Theme.of(context).primaryColor),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
