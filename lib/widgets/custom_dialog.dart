import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String contentText;
  final String actionText;
  final String? itemName;

  final Function onTapFunction;

  const CustomDialog({
    Key? key,
    required this.contentText,
    required this.actionText,
    required this.onTapFunction,
    this.itemName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff263742),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      title: const Text(
        'Confirm',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      content: itemName == null
          ? Text(
              contentText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          : RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: contentText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Arcade',
                ),
                children: [
                  TextSpan(
                    text: itemName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arcade',
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () async {
            onTapFunction();
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
          ),
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xffea3423),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color.fromARGB(255, 69, 171, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
