import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';

///
/// Material Text Field wrapped inside a Neumorphic background
/// @param type                         the theme
/// @param placeholder                  the placeholder string
/// @param obscureText                  boolean flag indicating hiding of characters (for passwords)
/// @param autoFocus
/// @param autoCorrect
/// @param maxLength
/// @param onSubmitted                  method to fire when field gets blurred
/// @param onChanged                    method to fire on every character change
/// @param inputFormatters              formattors for text
/// @param keyboardType                 type of keyboard to show
/// @param enableInteractiveSelection   whether to show cut/copy/etc options on text selection
/// @param enabled
/// @param prefixIcon
/// @param suffixIcon
/// @param focusNode
/// @param controller
/// @param margin
/// @param label
/// @param errorMessage
///

class ShipsyTextField extends StatelessWidget {
  final String placeholder;
  final bool obscureText;
  final bool autoFocus;
  final bool autoCorrect;
  final int maxLength;
  final Function onSubmitted;
  final Function onChanged;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool enableInteractiveSelection;
  final bool enabled;
  final Icon prefixIcon;
  final Widget suffixIcon;
  final FocusNode focusNode;
  final TextEditingController controller;
  final FIELD_TYPE type;
  final EdgeInsets margin;
  final String label;
  final String errorMessage;
  final int maxLines;
  final BoxConstraints suffixIconConstraints;
  final bool clearAllowed;

  const ShipsyTextField({
    Key key,
    @required this.placeholder,
    this.type: FIELD_TYPE.LIGHT,
    this.maxLength,
    this.obscureText: false,
    this.autoFocus: false,
    this.autoCorrect: false,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.keyboardType,
    this.enableInteractiveSelection: true,
    this.enabled: true,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.controller,
    this.margin: ShipsyEdgeInsets.ALL_0,
    this.label,
    this.errorMessage,
    this.maxLines: 1,
    this.suffixIconConstraints,
    this.clearAllowed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding = (maxLines != null && maxLines > 1)
        ? ShipsyEdgeInsets.HORIZONTAL_16.add(ShipsyEdgeInsets.VERTICAL_10)
        : ShipsyEdgeInsets.HORIZONTAL_16;
    Color textColor = this.enabled
        ? _colorMap[type][_colorTypes.textColor]
        : ShipsyColors.DISABLED_DARK;
    Color color = this.enabled
        ? _colorMap[type][_colorTypes.color]
        : ShipsyColors.DISABLED_LIGHT;
    Color embossColor = this.enabled
        ? _colorMap[type][_colorTypes.embossLightShadowColor]
        : Colors.transparent;
    Color embossDarkColor = _colorMap[type][_colorTypes.embossDarkShadowColor];
    BorderRadius borderRadius =
        BorderRadius.all(ShipsyBorderRadius.CIRCULAR_16);
    final TextTheme _textTheme = Theme.of(context).textTheme;
    final TextStyle textStyle = _textTheme.bodyText2.copyWith(
      color: textColor,
    );
    final TextStyle labelTextStyle = _textTheme.bodyText1.copyWith(
      color: _colorMap[type][_colorTypes.labelColor],
    );
    final Widget textField = ShipsyNeumorphic(
      margin: this.label == null ? margin : null,
      style: ShipsyNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius: borderRadius,
        depth: ShipsyNeumorphicTheme.EMBOSS_DEPTH_3,
        intensity: ShipsyNeumorphicTheme.INTENSITY_0P95,
        lightSource: LIGHT_SOURCE.TOP_LEFT,
        color: color,
        shadowLightColorEmboss: embossColor,
        shadowDarkColorEmboss: embossDarkColor,
      ),
      child: TextField(
        maxLines: this.maxLines,
        controller: this.controller,
        focusNode: this.focusNode,
        enabled: this.enabled,
        obscureText: this.obscureText,
        cursorColor: textColor,
        onSubmitted: this.onSubmitted,
        onChanged: this.onChanged,
        maxLength: this.maxLength,
        autofocus: this.autoFocus,
        autocorrect: this.autoCorrect,
        inputFormatters: this.inputFormatters,
        keyboardType: this.keyboardType,
        enableInteractiveSelection: this.enableInteractiveSelection,
        maxLengthEnforced: true,
        style: textStyle,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: this.prefixIcon,
          suffixIcon: clearAllowed != null
              ? (this.controller.text.length > 0
                  ? IconButton(
                      onPressed: () => this.controller.clear(),
                      icon: Icon(Icons.clear),
                    )
                  : null)
              : this.suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: borderRadius,
          ),
          hintText: this.placeholder,
          hintStyle: textStyle,
          contentPadding: contentPadding,
        ),
      ),
    );
    List<Widget> finalWidgets = [];
    if (label != null) {
      finalWidgets.add(
        Padding(
          padding: ShipsyEdgeInsets.LEFT_15.add(ShipsyEdgeInsets.BOTTOM_15),
          child: Text(
            label,
            style: labelTextStyle,
          ),
        ),
      );
    }

    finalWidgets.add(textField);

    if (errorMessage != null) {
      finalWidgets.add(Padding(
        padding: ShipsyEdgeInsets.LEFT_15.add(ShipsyEdgeInsets.TOP_10),
        child: Text(
          errorMessage,
          style: _textTheme.overline.copyWith(
            color: ShipsyColors.ERROR_DARK,
          ),
        ),
      ));
    }
    return finalWidgets.length == 1
        ? textField
        : Container(
            margin: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: finalWidgets,
            ),
          );
  }
}

enum FIELD_TYPE {
  LIGHT,
  DARK,
}

enum _colorTypes {
  textColor,
  color,
  embossLightShadowColor,
  embossDarkShadowColor,
  labelColor,
}

Map<FIELD_TYPE, Map<_colorTypes, Color>> _colorMap = {
  FIELD_TYPE.LIGHT: {
    _colorTypes.textColor: ShipsyColors.PRIMARY_DARK,
    _colorTypes.color: ShipsyColors.DEFAULT,
    _colorTypes.embossLightShadowColor:
        ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
    _colorTypes.embossDarkShadowColor:
        ShipsyNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
    _colorTypes.labelColor: ShipsyColors.SECONDARY_DARK,
  },
  FIELD_TYPE.DARK: {
    _colorTypes.textColor: ShipsyColors.DEFAULT,
    _colorTypes.color: ShipsyColors.PRIMARY_DARK,
    _colorTypes.embossLightShadowColor:
        ShipsyNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
    _colorTypes.embossDarkShadowColor:
        ShipsyNeumorphicTheme.DARK_SHADOW_DARK_THEME,
    _colorTypes.labelColor: ShipsyColors.SECONDARY_DARK,
  }
};
