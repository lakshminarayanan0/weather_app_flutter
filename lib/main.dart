import 'package:flutter/material.dart';
import 'package:new_one/weather_screen.dart';

void main() {
  //only for testing purpose
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color.fromARGB(255, 171, 245, 136)),
        home: const WeatherScreen());
  }
}
