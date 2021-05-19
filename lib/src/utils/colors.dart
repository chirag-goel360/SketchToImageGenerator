import 'dart:ui';

class ProjectColors {
  // will not be instantiated
  const ProjectColors._();

  // Primary
  static const Color DEFAULT = Color.fromRGBO(236, 240, 243, 1);
  static const Color PRIMARY_LIGHT = Color.fromRGBO(106, 146, 248, 1);
  static const Color PRIMARY_DARK = Color.fromRGBO(30, 43, 78, 1);

  // Secondary
  static const Color SECONDARY_DARK = Color.fromRGBO(110, 125, 165, 1);
  static const Color SECONDARY_LIGHT = Color.fromRGBO(210, 221, 244, 1);

  // Semantic
  static const Color SUCCESS_DARK = Color.fromRGBO(0, 193, 136, 1);
  static const Color SUCCESS_LIGHT = Color.fromRGBO(233, 245, 242, 1);

  static const Color ERROR_DARK = Color.fromRGBO(255, 86, 112, 1);
  static const Color ERROR_LIGHT = Color.fromRGBO(248, 239, 240, 1);

  static const Color INFO_DARK = PRIMARY_LIGHT;
  static const Color INFO_LIGHT = Color.fromRGBO(230, 233, 250, 1);

  static const Color WARNING_DARK = Color.fromRGBO(252, 164, 108, 1);
  static const Color WARNING_LIGHT = Color.fromRGBO(249, 241, 235, 1);

  // Disabled
  static const Color DISABLED_DARK = Color.fromRGBO(178, 184, 199, 1);
  static const Color DISABLED_LIGHT = Color.fromRGBO(228, 231, 239, 1);

  // Other
  static const Color DARK_GREY = Color.fromRGBO(68, 68, 68, 1);
}
