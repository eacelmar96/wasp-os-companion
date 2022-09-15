import 'package:flutter/material.dart';
import 'package:waspos/scripts/main.dart';
import 'package:workmanager/workmanager.dart';


import 'connect.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {return;});
}

// material app root

class App extends StatefulWidget {
  Key key;
  const App({
    required this.key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  // runs when the app is opened
  @override
  void initState() {
    super.initState();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerOneOffTask("io.github.taitberlette.wasp_os_companion.start", "io.github.taitberlette.wasp_os_companion.watchDisconnected");
    //start();
  }

  // runs when the app is closed
  @override
  void dispose() {
    super.dispose();
    stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Connect(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
