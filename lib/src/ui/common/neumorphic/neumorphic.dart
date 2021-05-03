import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';

enum BOX_SHAPE{
  CIRCLE,
  RECT,
  STADIUM,
  ROUND_RECT,
  BEVELED
}

enum LIGHT_SOURCE{
  TOP,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  LEFT,
  RIGHT
}

enum NEUMORPHIC_SHAPE{
   CONCAVE,
   CONVEX,
   FLAT
}

class ShipsyNeumorphic extends StatelessWidget {
  final Widget child;
  final ShipsyNeumorphicStyle style;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle textStyle;
  final bool drawSurfaceAboveChild;
  ShipsyNeumorphic(
      {Key key,
      @required this.child,
      @required this.style,
      this.padding: ShipsyEdgeInsets.ALL_0,
      this.margin: ShipsyEdgeInsets.ALL_0,
      this.textStyle,
      this.drawSurfaceAboveChild: true,
    })  :super(key: key);

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
    return Neumorphic(
      key: key,
      child: child,
      style: NeumorphicStyle(
          border: style.border,
          boxShape: _getBoxShape(),
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
      curve: Neumorphic.DEFAULT_CURVE,
      padding: padding,
      margin: margin,
      textStyle: textStyle,
      drawSurfaceAboveChild: drawSurfaceAboveChild,
    );
  }
}

class ShipsyNeumorphicStyle {
  final Color color;
  final double depth;
  final double intensity;
  final double surfaceIntensity;
  final LIGHT_SOURCE lightSource;
  final bool disableDepth;
  final NeumorphicBorder border;
  final bool oppositeShadowLightSource;
  final NEUMORPHIC_SHAPE shape;
  final BOX_SHAPE boxShape;
  final NeumorphicThemeData theme;
  final Color shadowLightColor;
  final Color shadowDarkColor;
  final Color shadowLightColorEmboss;
  final Color shadowDarkColorEmboss;
  final BorderRadius borderRadius;

  const ShipsyNeumorphicStyle({
    this.shape: NEUMORPHIC_SHAPE.FLAT,
    this.lightSource: LIGHT_SOURCE.TOP_LEFT,
    this.border: const NeumorphicBorder.none(),
    this.color,
    this.boxShape, 
    this.shadowLightColor,
    this.shadowDarkColor,
    this.shadowLightColorEmboss,
    this.shadowDarkColorEmboss,
    this.depth,
    this.intensity,
    this.surfaceIntensity: 0.25,
    this.disableDepth,
    this.oppositeShadowLightSource: false,
    this.borderRadius: BorderRadius.zero
  }) : this.theme = null;
}
