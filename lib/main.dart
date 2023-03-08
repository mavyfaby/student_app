import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studentapp/app/controllers/student_list.dart';

import 'app/db/students.dart';
import 'app/global/values.dart';
import 'app/theme/theme.dart';
import 'app/views/home.dart';

late bool isDarkMode;

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  // Get dark mode setting
  isDarkMode = await StudentDatabase.instance.getDarkMode();
  // Set app directory
  Values.appDirectory = (await getExternalStorageDirectory());

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

