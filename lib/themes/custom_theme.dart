import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData appTheme = ThemeData(
    fontFamily: 'Arcade',
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Color(0xff263742),
      centerTitle: true,
      elevation: 0.0,
    ),
  );
}
