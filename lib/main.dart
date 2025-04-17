import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Arduino IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily:
        //     'Kanit', // เพิ่มฟอนต์ที่สวยงาม (ต้องนำเข้าในไฟล์ pubspec.yaml ก่อน)
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade700,
          secondary: Colors.teal,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
