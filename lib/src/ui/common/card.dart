import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:humangenerator/src/utils/sized_boxes.dart';
import 'package:flutter/material.dart';

class ShipsyCard extends StatefulWidget {
  final Widget body;
  final Widget headingSuffix;
  final Widget tray;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final num bodyHeight;
  final String heading;

  const ShipsyCard({
    this.body,
    this.bodyHeight,
    this.tray,
    this.margin,
    this.padding,
    this.heading,
    this.headingSuffix,
    Key key,
  }) : super(key: key);

  @override
  _ShipsyCardState createState() => _ShipsyCardState();
}

class _ShipsyCardState extends State<ShipsyCard> {
  @override
  Widget build(BuildContext context) {
    return ShipsyNeumorphic(
      margin: widget.margin,
      padding: widget.padding != null ? widget.padding : ShipsyEdgeInsets.ALL_0,
      style: ShipsyNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius: BorderRadius.all(ShipsyBorderRadius.CIRCULAR_12),
        shape: NEUMORPHIC_SHAPE.FLAT,
        intensity: ShipsyNeumorphicTheme.INTENSITY_0P95,
        depth: ShipsyNeumorphicTheme.DEPTH_3,
        shadowLightColor: ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
        shadowDarkColor: ShipsyNeumorphicTheme.DARK_SHADOW_DARK_THEME,
        color: ShipsyColors.DEFAULT,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.heading != null)
            Container(
              padding: ShipsyEdgeInsets.HORIZONTAL_25
                  .add(ShipsyEdgeInsets.LEFT_10)
                  .add(ShipsyEdgeInsets.VERTICAL_15),
              color: ShipsyColors.SECONDARY_LIGHT,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.heading,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: ShipsyColors.PRIMARY_DARK),
                  ),
                  if (widget.headingSuffix != null) widget.headingSuffix,
                ],
              ),
            ),
          widget.bodyHeight != null
              ? Container(
                  height: widget.bodyHeight.toDouble(),
                  child: widget.body,
                )
              : widget.body,
          // ShipsySizedBoxes.HEIGHT_10,
          if (widget.tray != null) widget.tray,
        ],
      ),
    );
  }
}
