import 'package:flutter/material.dart';
import 'package:birthday_planer/widgets/navigation_widget.dart';
import 'package:birthday_planer/models/database.dart';
import 'package:provider/provider.dart';
import 'package:birthday_planer/models/selected_friends.dart';

void main() async {
  // Datenbank initialisieren
  WidgetsFlutterBinding.ensureInitialized();
  final db = Database();
  await db.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Database(),
      ),
      ChangeNotifierProvider(
        // TODO: Put further down the widget tree
        create: (context) => SelectedFriendsModel(),
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
        seedColor: Color.fromARGB(255, 56, 165, 184),
        brightness: Brightness.light,
      ).copyWith(
        primary: Color.fromARGB(255, 56, 165, 184),
        onPrimary: Colors.white,
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
      home: const NavigationWidget(),
    );
  }
}
