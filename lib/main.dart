import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import your splash screen here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ankur App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto', // optional, ensure this font exists in pubspec.yaml
      ),
      home: const SplashScreen(), // Starting screen of your app
    );
  }
}
