import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentapp/app/controllers/student_list.dart';

import 'app/db/students.dart';
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
    Get.put(StudentListController());

    return GetMaterialApp(
      title: 'Student app',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage()
    );
  }
}

