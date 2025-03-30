import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Flow 1.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
        ),
        fontFamily: 'Kanit',
      ),
      home: SplashScreen(),
    );
  }
}
