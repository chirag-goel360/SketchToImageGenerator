import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic_button.dart';
///
/// Neumorphic Button
/// @param type         PRIMARY or SECONDARY
/// @param isEnabled
/// @param buttonText
/// @param prefixIcon
/// @param onClick
/// @param margin
/// @param theme
/// @param size
///

enum ButtonTypes {
  PRIMARY,
  SECONDARY,
  DEFAULT,
  DARK,
  ERROR,
}
enum BUTTON_THEME {
  DARK,
  LIGHT,
}

enum BUTTON_SIZE {
  SMALL,
  LARGE,
}

class ProjectButton extends StatelessWidget {
  final ButtonTypes type;
  final bool isEnabled;
  final String buttonText;
  final Function onPressed;
  final IconData prefixIcon;
  final Image prefixImageIcon;
  final bool loading;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BUTTON_THEME theme;
  final BUTTON_SIZE size;

  const ProjectButton({
    Key key,
    @required this.onPressed,
    @required this.buttonText,
    this.isEnabled: true,
    this.type: ButtonTypes.PRIMARY,
    this.prefixIcon,
    this.prefixImageIcon,
    this.loading: false,
    this.margin: ProjectEdgeInsets.ALL_0,
    this.padding,
    this.theme: BUTTON_THEME.LIGHT,
    this.size: BUTTON_SIZE.LARGE,
  }) : super(key: key);

  Color _getButtonColor() {
    if (!isEnabled) {
      return ProjectColors.DISABLED_LIGHT;
    }
    Color buttonColor;
    switch (type) {
      case ButtonTypes.PRIMARY:
        buttonColor = ProjectColors.PRIMARY_LIGHT;
        break;
      case ButtonTypes.SECONDARY:
        buttonColor = ProjectColors.DEFAULT;
        break;
      case ButtonTypes.DARK:
        buttonColor = ProjectColors.PRIMARY_DARK;
        break;
      case ButtonTypes.ERROR:
        buttonColor = ProjectColors.ERROR_LIGHT;
        break;
      default:
        buttonColor = ProjectColors.DEFAULT;
    }
    return buttonColor;
  }

  Color _getButtonTextColor() {
    if (!isEnabled) {
      return ProjectColors.DISABLED_DARK;
    }
    Color buttonColor;
    switch (type) {
      case ButtonTypes.PRIMARY:
        buttonColor = ProjectColors.DEFAULT;
        break;
      case ButtonTypes.SECONDARY:
        buttonColor = ProjectColors.PRIMARY_LIGHT;
        break;
      case ButtonTypes.DARK:
        buttonColor = ProjectColors.DEFAULT;
        break;
      case ButtonTypes.ERROR:
        buttonColor = ProjectColors.ERROR_DARK;
        break;
      default:
        buttonColor = ProjectColors.PRIMARY_DARK;
    }
    return buttonColor;
  }

  Widget _buildButtonBody(TextStyle buttonStyle) {
    Widget buttonTextWidget = Text(
      buttonText,
      textAlign: TextAlign.center,
      style: buttonStyle.copyWith(
        color: _getButtonTextColor(),
      ),
    );
    List<Widget> prefixIconList = prefixIcon != null
        ? [
            Icon(
              prefixIcon,
              size: 24,
              color: _getButtonTextColor(),
            ),
            SizedBox(
              width: 10.0,
            )
          ]
        : [];
    prefixIconList = prefixImageIcon != null
        ? [
            prefixImageIcon,
            SizedBox(
              width: 10.0,
            )
          ]
        : [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: loading
          ? <Widget>[
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: _getButtonTextColor(),
                  valueColor: AlwaysStoppedAnimation(_getButtonColor()),
                ),
              )
            ]
          : <Widget>[
              ...prefixIconList,
              buttonTextWidget,
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProjectNeumorphicButton(
      margin: margin,
     
      padding: padding == null
          ? (ProjectEdgeInsets.LEFT_10.add(prefixIcon == null
              ? ProjectEdgeInsets.RIGHT_10
              : ProjectEdgeInsets.RIGHT_15))
          : padding,
      provideHapticFeedback: true,
      onClick: isEnabled && !loading ? onPressed : null,
      child: size == BUTTON_SIZE.LARGE
          ? Container(
              height: 54,
              child: _buildButtonBody(Theme.of(context).textTheme.button),
            )
          : Container(
              height: 46,
              child: _buildButtonBody(Theme.of(context).textTheme.subtitle2),
            ),
      style: ProjectNeumorphicStyle(
         boxShape: BOX_SHAPE.ROUND_RECT,
          borderRadius: BorderRadius.all(ProjectBorderRadius.CIRCULAR_14),
          shape: NEUMORPHIC_SHAPE.FLAT,
        depth: ProjectNeumorphicTheme.DEPTH_5,
        intensity: ProjectNeumorphicTheme.INTENSITY_MAX,
        lightSource: LIGHT_SOURCE.TOP_LEFT,
        color: _getButtonColor(),
        shadowLightColor: _shadowMap[theme][_shadowColorTypes.shadowLight],
        shadowDarkColor: _shadowMap[theme][_shadowColorTypes.shadowDark],
      ),
    );
  }
}

enum _shadowColorTypes {
  shadowLight,
  shadowDark,
}

Map<BUTTON_THEME, Map<_shadowColorTypes, Color>> _shadowMap = {
  BUTTON_THEME.LIGHT: {
    _shadowColorTypes.shadowLight:
        ProjectNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
    _shadowColorTypes.shadowDark: ProjectNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
  },
  BUTTON_THEME.DARK: {
    _shadowColorTypes.shadowLight:
        ProjectNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
    _shadowColorTypes.shadowDark: ProjectNeumorphicTheme.DARK_SHADOW_DARK_THEME,
  },
};
