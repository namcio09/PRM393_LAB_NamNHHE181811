import 'package:flutter/material.dart';
import 'package:lab4/ui/pages/HomePage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Lab4',
      // theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}



