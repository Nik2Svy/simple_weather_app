import 'package:flutter/material.dart';
import 'constants.dart';

// Тема всего сайта
@override
ThemeData myTheme() => ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kAccentColor,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: kTextColor,
      )),
      textTheme: const TextTheme(
        headline3: TextStyle(
          color: kTextColor,
          fontSize: 30,
        ),
        subtitle1: TextStyle(
          color: kTextColor,
          fontSize: 20,
        ),
      ),
    );
