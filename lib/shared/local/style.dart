import 'package:flutter/material.dart';

class AppStyle{
  static Color primaryColor = Color(0xff3598DB);
  static Color secondaryColor = Color(0xffBDBDBD);
  static Color labelColor = Color(0xff797979);
  static Color numberColor = Color(0xff7F7F7F);
  static Color messageColor = Color(0xffA1A1A1);
  static Color canvasColor = Color(0xffD3DFEF);
  static Color textColor = Color(0xff303030);
  static Color bodyColor = Color(0xff505050);
  static Color hint = Color(0xff282F39);
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22
      )
    ),
    primaryColor: primaryColor,
    secondaryHeaderColor: secondaryColor,
    canvasColor: canvasColor,
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 12,
        color: hint
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: labelColor
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white
      ),
      labelMedium: TextStyle(
          fontSize: 14,
          color: Colors.black
      ),
      labelSmall: TextStyle(
          fontSize: 10,
          color: Colors.black
      ),
      labelLarge: TextStyle(
          fontSize: 10,
          color: numberColor
      ),
      bodyLarge: TextStyle(
          fontSize: 18,
          color: primaryColor
      ),
      displayMedium: TextStyle(
          fontSize: 14,
          color: secondaryColor
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        color: bodyColor
      ),
      displayLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
      headlineMedium: TextStyle(
        fontSize: 12,
        color: numberColor
      )
    )
  );
}