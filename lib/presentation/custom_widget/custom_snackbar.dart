import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum SnackbarType { SUCCESS, ERROR, PROCESSING }

class CustomSnackbar {
  static show({
    required SnackbarType snackbarType,
    required String message,
    required BuildContext context,
    IconData? icon,
    Color? bgColor,
    Duration? duration,
  }) {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(12),
      elevation: 8,
      duration:
          duration ??
          (snackbarType == SnackbarType.PROCESSING
              ? const Duration(seconds: 5)
              : const Duration(seconds: 3)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              snackbarType == SnackbarType.ERROR ? Icons.warning : Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),

          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          snackbarType == SnackbarType.PROCESSING
              ? Colors.amber
              : snackbarType == SnackbarType.ERROR
              ? Colors.red
              : Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
