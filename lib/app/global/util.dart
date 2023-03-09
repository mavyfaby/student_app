import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
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

/// Compress an image and copy it to a new location
Future<File> compressImageAndCopy(File image, String destination) async {
  // Compress image
  File? result = await FlutterImageCompress.compressAndGetFile(
    image.absolute.path, 
    destination,
    quality: 20,
  );

  // If compression failed, return original image and show error
  if (result == null) {
    showCustomDialog("Error", "An error occured while compressing the image, using the original image instead.", [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Get.theme.colorScheme.onErrorContainer
        ),
        onPressed: () {
          Get.back();
        },
        child: const Text("Ok"),
      ),
    ]);

    return image;
  }

  // Return compressed image 
  return result;
}