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
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter > 9) _counter = _defaultCounterValue;
    });
    // Save current count to userPrefs
    _prefs?.setInt(_countPrefsKey, _counter);
    // Update home widget
    _homeWidgetController.setCount(count: _counter);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).primaryColor;
    _homeWidgetController.setBgColor(bgColor);
    return Scaffold(
      body: Stack(
        children: [
          HomeWidgetBgImage(count: _counter),
          // Counter widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
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
}
