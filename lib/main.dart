import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'app/db/student.dart';
import 'app/theme/theme.dart';
import 'app/views/home.dart';

late Database db;
late bool isDarkMode;

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  db = await StudentDatabase.instance.database;
  isDarkMode = await StudentDatabase.instance.getDarkMode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? darkTheme : lightTheme;

    return ThemeProvider(
      initTheme: theme,
      builder: (_, theme) {
        return MaterialApp(
          title: 'Student app',
          theme: theme,
          home: const HomePage(),
        );
      }
    );
  }
}

