import 'package:flutter/material.dart';

class MyColors {
  static final myWhite = Color(0xFFF7F7F7);
  static final myBlack = Color(0xFF242947);

  static final greyImran = Color(0xFF9b9b9b);
  static final greyImran2 = Color(0xFFcecece);

  static final biruImran = Color(0xFF324fcc);
  static final biruImran2 = Color(0xFF14256d);
  static final biruImran3 = Color(0xFFbecbf4);
  static final biruImran4 = Color(0xFFe1e7ff);
  static final biruImran5 = Color(0xFF2a3a91);

  static final biruSelect = Color(0xFF2d55ff);

  static final hijauImran = Color(0xFFb3e8ac);
  static final hijauImran2 = Color(0xFF33cc33);
  static final hijauImran3 = Color(0xFF086d0a);

  static final merahImran = Color(0xFFf7394c);

  static final rankInfant = Color(0xFF3f3f3f);
}

class MyTheme {
  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',

    primaryColor: MyColors.myWhite,
    brightness: Brightness.light,

    pageTransitionsTheme: PageTransitionsTheme(builders: { TargetPlatform.android: CupertinoPageTransitionsBuilder() }),

    textTheme: TextTheme(
      displayLarge: TextStyle(),
      displayMedium: TextStyle(),
      displaySmall: TextStyle(),

      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),

      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),

      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),

      labelLarge: TextStyle(),
      labelMedium: TextStyle(),
      labelSmall: TextStyle(),
    ).apply(
      bodyColor: MyColors.biruImran2,
      displayColor: MyColors.biruImran2,
      decorationColor: MyColors.biruImran2
    ),

    iconTheme: IconThemeData(
      color: MyColors.biruImran2
    ),

    scaffoldBackgroundColor: MyColors.myWhite,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: MyColors.biruImran,

      primary: MyColors.biruImran,
      secondary: MyColors.biruImran2,
      tertiary: MyColors.biruImran3,
      onPrimary: MyColors.biruImran4,

      onSecondary: MyColors.myWhite,
      onTertiary: MyColors.biruImran5,
      onPrimaryContainer: MyColors.greyImran,

      outline: MyColors.biruSelect,
      outlineVariant: MyColors.hijauImran3,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',

    primaryColor: MyColors.myBlack,
    brightness: Brightness.dark,

    pageTransitionsTheme: PageTransitionsTheme(builders: { TargetPlatform.android: CupertinoPageTransitionsBuilder() }),

    textTheme: TextTheme(
      displayLarge: TextStyle(),
      displayMedium: TextStyle(),
      displaySmall: TextStyle(),

      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),

      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),

      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),

      labelLarge: TextStyle(),
      labelMedium: TextStyle(),
      labelSmall: TextStyle(),
    ).apply(
      bodyColor: MyColors.myWhite,
      displayColor: MyColors.myWhite,
      decorationColor: MyColors.myWhite
    ),

    iconTheme: IconThemeData(
      color: MyColors.biruImran3
    ),

    scaffoldBackgroundColor: MyColors.myBlack,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: MyColors.biruImran,

      primary: MyColors.biruImran4,
      secondary: MyColors.biruImran3,
      tertiary: MyColors.biruImran2,
      onPrimary: MyColors.biruImran,

      onSecondary: MyColors.biruImran5,
      onTertiary: MyColors.myWhite,
      onPrimaryContainer: MyColors.greyImran2,

      outline: MyColors.biruImran3,
      outlineVariant: MyColors.hijauImran2,
    ),
  );
}