import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    // bodyLarge: TextStyle(
    //   color: Colors.black,
    // ),
    headlineLarge: TextStyle(color: Colors.black, fontSize: 36),
    headlineMedium: TextStyle(color: Colors.black, fontSize: 27),
    headlineSmall: TextStyle(color: Colors.black, fontSize: 24),
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    // headlineLarge: TextStyle(color: Colors.white, fontSize: 36),
    // headlineMedium: TextStyle(color: Colors.white, fontSize: 27),
    // headlineSmall: TextStyle(color: Colors.white, fontSize: 24),
    // bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    // bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  ),
);
