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

class ProjectIconButton extends StatelessWidget {
  final IconData icon;
  final ICON_BUTTON_THEMES theme;
  final void Function() onPressed;
  final bool disabled;
  final bool selected;

  const ProjectIconButton({
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
            _colorMapKeys.BG: ProjectColors.DEFAULT,
            _colorMapKeys.ICON: ProjectColors.PRIMARY_DARK,
            _colorMapKeys.LIGHT_SHADOW:
                ProjectNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
            _colorMapKeys.DARK_SHADOW:
                ProjectNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
          }
        : {
            _colorMapKeys.BG: ProjectColors.PRIMARY_DARK,
            _colorMapKeys.ICON: ProjectColors.DEFAULT,
            _colorMapKeys.LIGHT_SHADOW:
                ProjectNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
            _colorMapKeys.DARK_SHADOW:
                ProjectNeumorphicTheme.DARK_SHADOW_DARK_THEME,
          };
    if (disabled) {
      colorMap[_colorMapKeys.BG] = ProjectColors.DISABLED_LIGHT;
      colorMap[_colorMapKeys.ICON] = ProjectColors.DISABLED_DARK;
    } else if (selected) {
      colorMap[_colorMapKeys.BG] = ProjectColors.PRIMARY_LIGHT;
      colorMap[_colorMapKeys.ICON] = ProjectColors.DEFAULT;
    }
    return colorMap;
  }

  @override
  Widget build(BuildContext context) {
    Map<_colorMapKeys, Color> colorData = _getColorMap();
    return ProjectNeumorphicButton(
      padding: ProjectEdgeInsets.ALL_10,
      style: ProjectNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius:BorderRadius.all(ProjectBorderRadius.CIRCULAR_16) ,
        shape: NEUMORPHIC_SHAPE.FLAT,
        depth: selected
            ? ProjectNeumorphicTheme.EMBOSS_DEPTH_3
            : ProjectNeumorphicTheme.DEPTH_5,
        intensity: ProjectNeumorphicTheme.INTENSITY_MAX,
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
