import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ShipsyNeumorphicTheme {
  const ShipsyNeumorphicTheme._();

  // Emboss Depth
  static const double EMBOSS_DEPTH_3 = -3;
  static const double EMBOSS_DEPTH_4 = -4;
  static const double EMBOSS_DEPTH_5 = -5;

  // Non Emboss Depth
  static const double DEPTH_3 = 3;
  static const double DEPTH_5 = 5;
  static const double DEPTH_18 = 18;

  // Intensity
  static const double INTENSITY_0P6 = 0.6;
  static const double INTENSITY_0P85 = 0.85;
  static const double INTENSITY_0P95 = 0.95;
  static const double INTENSITY_MAX = 1;

  // Shadow Colors
  static const Color DARK_SHADOW_DARK_THEME =
      NeumorphicColors.embossMaxDarkColor;
  static const Color LIGHT_SHADOW_DARK_THEME =
      Color.fromRGBO(106, 146, 248, 0.4);
  static const Color LIGHT_SHADOW_LIGHT_THEME = Colors.white;
  static const Color DARK_SHADOW_LIGHT_THEME =
      Color.fromRGBO(110, 125, 165, 0.5);
}
