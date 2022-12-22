import 'package:flutter/material.dart';

Color baseColor = const Color.fromARGB(255, 174, 253, 177);
Color secColor = const Color.fromARGB(255, 99, 255, 105);
Color sec2Color = const Color.fromARGB(255, 50, 128, 52);

MaterialColor colors = MaterialColor(
  sec2Color.value,
  <int, Color>{0: sec2Color, 1: secColor, 2: baseColor},
);
class MyTheme {

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[800],
    fontFamily: 'Lato,',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: colors)
        .copyWith(secondary: Colors.deepOrange),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[800],
    fontFamily: 'Lato,',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
        .copyWith(secondary: Colors.deepOrange),
  );
}
