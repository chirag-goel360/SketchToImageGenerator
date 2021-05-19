import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:humangenerator/src/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';

class ProjectPanel extends StatelessWidget {
  final String heading;
  final Map<String, Widget> dataList;
  final EdgeInsets margin;
  final bool darkHeading;
  final Widget tray;
  final Widget description;
  final Widget headingSuffix;

  const ProjectPanel({
    Key key,
    @required this.heading,
    @required this.dataList,
    this.margin: ProjectEdgeInsets.ALL_0,
    this.darkHeading: false,
    this.tray,
    this.description,
    this.headingSuffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProjectNeumorphic(
      margin: margin,
      padding: ProjectEdgeInsets.ALL_0,
      
      style: ProjectNeumorphicStyle(
        boxShape:BOX_SHAPE.ROUND_RECT,
        borderRadius: BorderRadius.all(ProjectBorderRadius.CIRCULAR_12),
        shape: NEUMORPHIC_SHAPE.FLAT,
        intensity: ProjectNeumorphicTheme.INTENSITY_0P95,
        depth: ProjectNeumorphicTheme.DEPTH_3,
        shadowLightColor: ProjectNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
        shadowDarkColor: ProjectNeumorphicTheme.DARK_SHADOW_DARK_THEME,
        color: ProjectColors.DEFAULT,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: ProjectEdgeInsets.HORIZONTAL_25
                .add(ProjectEdgeInsets.VERTICAL_10),
            color: ProjectColors.SECONDARY_LIGHT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: darkHeading
                            ? ProjectColors.PRIMARY_DARK
                            : ProjectColors.PRIMARY_LIGHT,
                      ),
                ),
                if (headingSuffix != null) headingSuffix
              ],
            ),
          ),
          description != null
              ? Container(
                  margin: ProjectEdgeInsets.VERTICAL_10
                      .add(ProjectEdgeInsets.HORIZONTAL_25),
                  child: description,
                )
              : Container(
                  margin: ProjectEdgeInsets.VERTICAL_10
                      .add(ProjectEdgeInsets.HORIZONTAL_25),
                  child: Column(
                    children: dataList.keys
                        .map<Widget>(
                          (e) => Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: ProjectEdgeInsets.VERTICAL_4,
                                  child: Text(
                                    e.contains(Strings
                                            .DUPLICATE_ALLOW_PROJECT_PANEL)
                                        ? e.substring(
                                            0,
                                            e.indexOf(Strings
                                                .DUPLICATE_ALLOW_PROJECT_PANEL))
                                        : e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                          letterSpacing: 0,
                                          color: ProjectColors.SECONDARY_DARK,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: ProjectEdgeInsets.VERTICAL_4,
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
