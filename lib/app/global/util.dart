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