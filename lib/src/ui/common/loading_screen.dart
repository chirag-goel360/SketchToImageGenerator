import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/ui/common/loading_indicator.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';

OverlayEntry _overlayEntry;

void removeShipsyLoadingScreen(BuildContext context) {
  if (_overlayEntry != null) {
    _overlayEntry.remove();
    _overlayEntry = null;
  }
}

void showShipsyLoadingScreen(BuildContext context, String messageCode) {
  removeShipsyLoadingScreen(context);
  _overlayEntry = _createOverlayEntry(messageCode);
  Overlay.of(context).insert(_overlayEntry);
}

OverlayEntry _createOverlayEntry(String messageCode) {
  return OverlayEntry(
    builder: (context) => Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        color: Colors.black12.withOpacity(0.3),
        child: Center(
          child: FittedBox(
            child: ShipsyNeumorphic(
              padding: ShipsyEdgeInsets.ALL_20,
              style: ShipsyNeumorphicStyle(
                boxShape: BOX_SHAPE.ROUND_RECT,
                borderRadius: BorderRadius.all(ShipsyBorderRadius.CIRCULAR_16),
                color: ShipsyColors.DEFAULT,
                shape: NEUMORPHIC_SHAPE.FLAT,
                intensity: ShipsyNeumorphicTheme.INTENSITY_0P95,
                depth: ShipsyNeumorphicTheme.DEPTH_5,
                lightSource: LIGHT_SOURCE.TOP_LEFT,
                shadowLightColor: ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME
                    .withOpacity(0.5),
                shadowDarkColor: ShipsyNeumorphicTheme.DARK_SHADOW_DARK_THEME,
              ),
              child: Row(
                children: <Widget>[
                  CenterLoadingIndicator(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    AppLocalization.of(context).translate(messageCode),
                    style: Theme.of(context).textTheme.overline.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
