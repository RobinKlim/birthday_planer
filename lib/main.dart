import 'package:birthday_planer/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = Database();
  await db.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Database(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(145, 111, 161, 1),
        brightness: Brightness.light,
      ).copyWith(
        primary: Color.fromRGBO(145, 111, 161, 1),
        onPrimary: Colors.white,
        secondary: Color.fromRGBO(115, 179, 149, 1),
        onSecondary: Colors.white,
        tertiary: Color.fromRGBO(153, 138, 115, 1),
        onTertiary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
    );

    return MaterialApp(
      theme: theme.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
      home: const StartPage(),
    );
  }
}
