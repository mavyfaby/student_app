import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:studentapp/app/db/student.dart';
import 'package:studentapp/app/pages/add_student.dart';

import 'app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String path = await getDatabasesPath();
  path = join(path, "student.db");
  var db = await openDatabase(path);

  StudentDatabase(db);
  runApp(const MyApp());
}

ThemeData lm = ThemeData(useMaterial3: true, colorScheme: lightColorScheme);
ThemeData dm = ThemeData(useMaterial3: true, colorScheme: darkColorScheme);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlatformDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? lm : dm;

    return ThemeProvider(
      initTheme: initTheme,
      builder: (_, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: const HomePage(),
        );
      }
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student app"),
        actions: [
          ThemeSwitcher.withTheme(
            builder: (_, switcher, theme) {
               return Switch(
                value: theme.brightness == Brightness.dark,
                thumbIcon:  MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Icon(Icons.dark_mode_rounded);
                  }

                  return const Icon(Icons.sunny);
                }),
                onChanged: (val) => {
                  switcher.changeTheme(
                    theme: theme.brightness == Brightness.light ? dm : lm,
                  )
                }
              );
            },
          ),
          IconButton(
            tooltip: "Add student",
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (b) => const AddStudentPage()));
            },
          )
        ],
      ),
      body: const Center(
        child: Text("Test")
      )
    );
  }
}
