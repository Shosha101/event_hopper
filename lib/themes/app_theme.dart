import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
    ).copyWith(
        surface: Colors.white, // Set surface color to white
        onSurface: Colors.black, // Text color on surface
        primary: Colors.black, // Set primary color to black
      outline: Color.fromRGBO(244, 63, 139, 1.0)
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(

    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      outline: Colors.white,
      seedColor: Colors.white,
      brightness: Brightness.dark,
    ).copyWith(
        primary: Colors.white, // Set primary color to white
        onSurface: Colors.white, // Text color on dark surface
        surface: Colors.black, // Set surface color to black
        onPrimary: Colors.black,


    ),
  );
}
