import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Show an overlay with a message
void showOverlay(String message) {
  Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(32),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message)
            ],
          ),
        )
      )
    );
}

// Enum for the type of error
enum DialogType {
  error,
  success,
}

/// Show a dialog with a message
void showCustomDialog(String title, String message, List<Widget> actions, { DialogType type = DialogType.success }) {
  Get.dialog(
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: type == DialogType.error ? Get.theme.colorScheme.errorContainer : Get.theme.dialogBackgroundColor,
        title: Text(title),
        content: Text(message),
        actions: actions,
      )
    )
  );
}