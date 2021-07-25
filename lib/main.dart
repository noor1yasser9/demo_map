import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:web_map/screen/HomePage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF383737), // navigation bar color
      statusBarColor: Color(0xFF383737),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:  Colors.white// status bar color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter GoogleMaps Demo',
      home: HomePage(),
    );
  }
}
