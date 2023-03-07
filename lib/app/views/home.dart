import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

import '../db/student.dart';
import '../theme/theme.dart';
import 'add_student.dart';

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
                onChanged: (val) async {
                  switcher.changeTheme(
                    theme: theme.brightness == Brightness.light ? darkTheme: lightTheme,
                  );

                  // Update darkmode in database
                  StudentDatabase.instance.updateDarkmode(theme.brightness == Brightness.light);
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
