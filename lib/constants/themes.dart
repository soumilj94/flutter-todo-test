import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  appBarTheme: const AppBarTheme(backgroundColor: teal),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: fab, foregroundColor: black),
  scaffoldBackgroundColor: background,
  bottomSheetTheme: const BottomSheetThemeData(modalBackgroundColor: background),
  inputDecorationTheme: const InputDecorationTheme(focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: teal, width: 2))),
  elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(teal), foregroundColor: WidgetStatePropertyAll(white)))
);