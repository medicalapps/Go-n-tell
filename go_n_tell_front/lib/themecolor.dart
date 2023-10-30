import 'dart:math';

import 'package:flutter/material.dart';

Color getThemeColor(int index, double colorOpacity) {
  Color returnColor;

  var themeColors = [
    const Color.fromARGB(255, 211, 56, 108),
    const Color.fromARGB(255, 65, 207, 70),
    const Color.fromARGB(255, 81, 143, 195),
    const Color.fromARGB(33, 135, 59, 150),
    const Color.fromARGB(255, 123, 118, 72),
    const Color.fromARGB(255, 64, 88, 99),
    const Color.fromARGB(255, 147, 189, 98),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
  ];
  if (index <= 0 || index > themeColors.length) {
    var number = Random().nextInt(themeColors.length - 1);
    index = number;
  }

  returnColor = themeColors[index]!;

  int hexOpacity = (255 * colorOpacity).toInt();
  returnColor = returnColor.withAlpha(hexOpacity);

  return returnColor;
}
