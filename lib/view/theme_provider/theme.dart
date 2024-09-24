import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  // colorScheme: ColorScheme.fromSwatch().copyWith(
  //   primary: Colors.grey,
  //   secondary: Colors.black,
  // ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 36),
    headlineMedium: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 27),
    headlineSmall: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 24),
    bodyLarge: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(fontFamily: 'Inter',color: Colors.black, fontSize: 14),
  ),
  iconTheme: const IconThemeData(
    size: 24,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.grey[900],
    secondary: Colors.purple,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Inter',color: Colors.white, fontSize: 36),
    headlineMedium: TextStyle(fontFamily: 'Inter',color: Colors.white, fontSize: 27),
    headlineSmall: TextStyle(fontFamily: 'Inter',color: Colors.white, fontSize: 24),
    bodyLarge: TextStyle(fontFamily: 'Inter',color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(fontFamily: 'Inter',color: Colors.white, fontSize: 14),
  ),
  iconTheme: const IconThemeData(
    size: 24,
  ),
);