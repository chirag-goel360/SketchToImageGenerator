import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';

class ShipsyNeumorphicButton extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final Function onClick;
  final bool provideHapticFeedback;
  final ShipsyNeumorphicStyle style;
  final double minDistance;
  final String tooltip;
  final bool pressed;

  const ShipsyNeumorphicButton(
      {Key key,
      this.margin: ShipsyEdgeInsets.ALL_0,
      this.padding: ShipsyEdgeInsets.ALL_0,
      @required this.child,
      this.onClick,
      this.provideHapticFeedback: true,
      this.style,
      this.minDistance,
      this.tooltip,
      this.pressed})
      : super(key: key);

  LightSource _getLightSource() {
    LightSource lightSource;
    switch (style.lightSource) {
      case LIGHT_SOURCE.TOP:
        lightSource = LightSource.top;
        break;
      case LIGHT_SOURCE.TOP_LEFT:
        lightSource = LightSource.topLeft;
        break;
      case LIGHT_SOURCE.TOP_RIGHT:
        lightSource = LightSource.topRight;
        break;
      case LIGHT_SOURCE.BOTTOM:
        lightSource = LightSource.bottom;
        break;
      case LIGHT_SOURCE.BOTTOM_LEFT:
        lightSource = LightSource.bottomLeft;
        break;
      case LIGHT_SOURCE.BOTTOM_RIGHT:
        lightSource = LightSource.bottomRight;
        break;
      case LIGHT_SOURCE.LEFT:
        lightSource = LightSource.left;
        break;
      case LIGHT_SOURCE.RIGHT:
        lightSource = LightSource.right;
        break;
      default:
        lightSource = LightSource.topLeft;
    }
    return lightSource;
  }

  NeumorphicBoxShape _getBoxShape(){

    NeumorphicBoxShape boxShape;
    switch (style.boxShape) {
      case BOX_SHAPE.CIRCLE:
        boxShape = NeumorphicBoxShape.circle();
        break;
      case BOX_SHAPE.RECT:
        boxShape = NeumorphicBoxShape.rect();
        break;
      case BOX_SHAPE.ROUND_RECT:
        boxShape = NeumorphicBoxShape.roundRect(style.borderRadius);
        break;
      case BOX_SHAPE.STADIUM:
        boxShape = NeumorphicBoxShape.stadium();
        break;
      case BOX_SHAPE.BEVELED:
        boxShape = NeumorphicBoxShape.beveled(style.borderRadius);
        break;
      default:
        boxShape = NeumorphicBoxShape.circle();
    }
    return boxShape;
  }

  NeumorphicShape _getShape(){

    NeumorphicShape shape ;
    switch (style.shape) {
      case NEUMORPHIC_SHAPE.CONCAVE:
        shape = NeumorphicShape.concave;
        break;
      case NEUMORPHIC_SHAPE.FLAT:
        shape = NeumorphicShape.flat;
        break;
      case NEUMORPHIC_SHAPE.CONVEX:
        shape = NeumorphicShape.convex;
        break;
      default:
        shape = NeumorphicShape.flat;
    }
    return shape;
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: margin,
      padding: padding,
      child: child,
      onPressed: onClick,
      curve: Neumorphic.DEFAULT_CURVE,
      provideHapticFeedback: provideHapticFeedback,
      style: NeumorphicStyle(
          border: style.border,
          boxShape:_getBoxShape() ,
          color: style.color,
          depth: style.depth,
          disableDepth: style.disableDepth,
          intensity: style.intensity,
          lightSource: _getLightSource(),
          oppositeShadowLightSource: style.oppositeShadowLightSource,
          shadowDarkColor: style.shadowDarkColor,
          shadowDarkColorEmboss: style.shadowDarkColorEmboss,
          shadowLightColor: style.shadowLightColor,
          shadowLightColorEmboss: style.shadowLightColorEmboss,
          shape: _getShape(),
          surfaceIntensity: style.surfaceIntensity),
      minDistance: minDistance,
      pressed: pressed,
      tooltip: tooltip,
    );
  }
}
