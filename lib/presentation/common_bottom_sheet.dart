import 'package:flutter/material.dart';

class CommonBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    double initialChildSize = 0.5,
    bool isDismissible = false,
    bool enableDrag = false,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            color: backgroundColor ?? Colors.white,
            shape:
                shape ??
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [child]),
          ),
        );
      },
    );
  }
}
