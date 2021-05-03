import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:humangenerator/src/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';

class ShipsyPanel extends StatelessWidget {
  final String heading;
  final Map<String, Widget> dataList;
  final EdgeInsets margin;
  final bool darkHeading;
  final Widget tray;
  final Widget description;
  final Widget headingSuffix;

  const ShipsyPanel({
    Key key,
    @required this.heading,
    @required this.dataList,
    this.margin: ShipsyEdgeInsets.ALL_0,
    this.darkHeading: false,
    this.tray,
    this.description,
    this.headingSuffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShipsyNeumorphic(
      margin: margin,
      padding: ShipsyEdgeInsets.ALL_0,
      
      style: ShipsyNeumorphicStyle(
        boxShape:BOX_SHAPE.ROUND_RECT,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: ShipsyEdgeInsets.HORIZONTAL_25
                .add(ShipsyEdgeInsets.VERTICAL_10),
            color: ShipsyColors.SECONDARY_LIGHT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: darkHeading
                            ? ShipsyColors.PRIMARY_DARK
                            : ShipsyColors.PRIMARY_LIGHT,
                      ),
                ),
                if (headingSuffix != null) headingSuffix
              ],
            ),
          ),
          description != null
              ? Container(
                  margin: ShipsyEdgeInsets.VERTICAL_10
                      .add(ShipsyEdgeInsets.HORIZONTAL_25),
                  child: description,
                )
              : Container(
                  margin: ShipsyEdgeInsets.VERTICAL_10
                      .add(ShipsyEdgeInsets.HORIZONTAL_25),
                  child: Column(
                    children: dataList.keys
                        .map<Widget>(
                          (e) => Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: ShipsyEdgeInsets.VERTICAL_4,
                                  child: Text(
                                    e.contains(Strings
                                            .DUPLICATE_ALLOW_SHIPSY_PANEL)
                                        ? e.substring(
                                            0,
                                            e.indexOf(Strings
                                                .DUPLICATE_ALLOW_SHIPSY_PANEL))
                                        : e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                          letterSpacing: 0,
                                          color: ShipsyColors.SECONDARY_DARK,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: ShipsyEdgeInsets.VERTICAL_4,
                                  child: dataList[e],
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
          if (tray != null) tray
        ],
      ),
    );
  }
}
