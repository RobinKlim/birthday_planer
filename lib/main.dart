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
            seedColor: Colors.blue,
            brightness: Brightness.light,
          )),
      home: const NavigationWidget(),
    );
  }
}
