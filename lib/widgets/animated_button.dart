import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../themes/text_styles.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final RoundedLoadingButtonController buttonController;
  final Function onPressed;

  const AnimatedButton({
    Key? key,
    required this.text,
    required this.buttonController,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return RoundedLoadingButton(
      height: deviceHeight * 0.055,
      width: deviceWidth * 0.80,
      color: const Color(0xFF59b7b9),
      borderRadius: 5.0,
      controller: buttonController,
      onPressed: () => onPressed(),
      resetDuration: const Duration(milliseconds: 2000),
      resetAfterDuration: true,
      child: Text(
        text,
        style: TextStyles.buttonTextStyle,
      ),
    );
  }
}
