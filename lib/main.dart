import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/navigation_widget.dart'; // Import the new navigation widget

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.pinkAccent,
          onPrimary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
      ),
      home: const NavigationWidget(),
    );
  }
}
