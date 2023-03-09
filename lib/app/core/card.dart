import 'dart:io';

import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentapp/app/global/values.dart';

import 'student.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.onDelete});

  final Student student;
  final Function(Student) onDelete;

  @override
  Widget build(BuildContext context) {
    return PressableDough(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Get.theme.brightness == Brightness.dark ? Get.theme.colorScheme.surfaceVariant : Get.theme.colorScheme.surface,
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File("${Values.appDirectory!.path}/${student.image}"), fit: BoxFit.cover, width: double.infinity, height: 150)
                )
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(student.name, style: Get.textTheme.titleLarge)
                    ),
                    Text(student.course),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () => onDelete(student),
                          child: const Text("Delete")
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}