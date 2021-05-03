import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic_button.dart';

///
/// Neumorphic Icon Button
///
/// @params icon
/// @params onPressed
/// @params disabled
/// @params selected
/// @params theme
///

class ShipsyIconButton extends StatelessWidget {
  final IconData icon;
  final ICON_BUTTON_THEMES theme;
  final void Function() onPressed;
  final bool disabled;
  final bool selected;

  const ShipsyIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
    this.disabled: false,
    this.selected: false,
    this.theme: ICON_BUTTON_THEMES.LIGHT,
  }) : super(key: key);

  Map<_colorMapKeys, Color> _getColorMap() {
    Map<_colorMapKeys, Color> colorMap = theme == ICON_BUTTON_THEMES.LIGHT
        ? {
            _colorMapKeys.BG: ShipsyColors.DEFAULT,
            _colorMapKeys.ICON: ShipsyColors.PRIMARY_DARK,
            _colorMapKeys.LIGHT_SHADOW:
                ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
            _colorMapKeys.DARK_SHADOW:
                ShipsyNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
          }
        : {
            _colorMapKeys.BG: ShipsyColors.PRIMARY_DARK,
            _colorMapKeys.ICON: ShipsyColors.DEFAULT,
            _colorMapKeys.LIGHT_SHADOW:
                ShipsyNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
            _colorMapKeys.DARK_SHADOW:
                ShipsyNeumorphicTheme.DARK_SHADOW_DARK_THEME,
          };
    if (disabled) {
      colorMap[_colorMapKeys.BG] = ShipsyColors.DISABLED_LIGHT;
      colorMap[_colorMapKeys.ICON] = ShipsyColors.DISABLED_DARK;
    } else if (selected) {
      colorMap[_colorMapKeys.BG] = ShipsyColors.PRIMARY_LIGHT;
      colorMap[_colorMapKeys.ICON] = ShipsyColors.DEFAULT;
    }
    return colorMap;
  }

  @override
  Widget build(BuildContext context) {
    Map<_colorMapKeys, Color> colorData = _getColorMap();
    return ShipsyNeumorphicButton(
      padding: ShipsyEdgeInsets.ALL_10,
      style: ShipsyNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius:BorderRadius.all(ShipsyBorderRadius.CIRCULAR_16) ,
        shape: NEUMORPHIC_SHAPE.FLAT,
        depth: selected
            ? ShipsyNeumorphicTheme.EMBOSS_DEPTH_3
            : ShipsyNeumorphicTheme.DEPTH_5,
        intensity: ShipsyNeumorphicTheme.INTENSITY_MAX,
        color: colorData[_colorMapKeys.BG],
        shadowLightColorEmboss: colorData[_colorMapKeys.LIGHT_SHADOW],
        shadowLightColor: colorData[_colorMapKeys.LIGHT_SHADOW],
        shadowDarkColor: colorData[_colorMapKeys.DARK_SHADOW],
        shadowDarkColorEmboss: colorData[_colorMapKeys.DARK_SHADOW],
      ),
      child: Icon(
        this.icon,
        size: 24.0,
        color: colorData[_colorMapKeys.ICON],
      ),
      onClick: !disabled ? this.onPressed : null,
    );
  }
}

enum ICON_BUTTON_THEMES {
  LIGHT,
  DARK,
}

enum _colorMapKeys {
  ICON,
  BG,
  LIGHT_SHADOW,
  DARK_SHADOW,
}
