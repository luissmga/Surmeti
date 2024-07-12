import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color boxColor = Colors.lightBlue;
  static const Color dividerColor = Colors.purple;

  static const TextStyle appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  static const TextStyle boxTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle dropdownTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        titleTextStyle: appBarTextStyle,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, 
          backgroundColor: Colors.black,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
    );
  }
}
