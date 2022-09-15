import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../themes/text_styles.dart';

class CustomSnackBar {
  final String text;

  CustomSnackBar({
    required this.text,
  });

  Future<dynamic> showSnackbar(BuildContext context) async {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xff263742),
      messageText: Center(
        child: Text(
          text,
          style: TextStyles.bodyMedium,
        ),
      ),
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}
