import 'dart:async';

import 'package:flutter/services.dart';
import 'package:waspos/scripts/debug.dart';
import 'package:waspos/scripts/device.dart';
import 'package:waspos/scripts/storage.dart';
import 'package:workmanager/workmanager.dart;

Timer syncTimer;
//Timer scanrTimer; //xk
MethodChannel methodChannel;

// init
void start() {
  syncTimer = Timer.periodic(Duration(minutes: 10), sync);
  //scanrTimer = Timer.periodic(Duration(minutes: 1), scanr); //xk

  methodChannel =
      MethodChannel("io.github.taitberlette.wasp_os_companion/messages");

  methodChannel.setMethodCallHandler(channel);

  methodChannel.invokeMethod("connectedToChannel");

  Device.start();
  Storage.start();
}

// sync
void sync(Timer timer) {
  Device.sync();
}

//xk
void scanr(Timer timer){
  Device.scanr();
}

// handle messages from the native code
Future<void> channel(MethodCall call) {
  switch (call.method) {
    case "watchConnecting":
      Device.connecting(call.arguments["data"]);
      break;
    case "watchConnected":
      Device.connected(call.arguments["main"], call.arguments["extra"]);
      break;
    case "watchDisconnected":
      Device.disconnected();
      Device.connect(); //xk
      break;
    case "watchUart":
      Debug.uartData(call.arguments["data"]);
      break;
    case "watchCommand":
      break;
    case "watchResponse":
      Device.response(call.arguments["main"], call.arguments["extra"]);
      break;
    case "askNotifications":
      Device.askNotifications();
      break;
  }

  return null;
}

// dispose
void stop() {
  Device.stop();
  Debug.stop();

  syncTimer.cancel();
  //scanrTimer.cancel();
}
