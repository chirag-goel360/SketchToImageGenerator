import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final Widget body;
  final Widget headingSuffix;
  final Widget tray;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final num bodyHeight;
  final String heading;

  const ProjectCard({
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
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    return ProjectNeumorphic(
      margin: widget.margin,
      padding: widget.padding != null ? widget.padding : ProjectEdgeInsets.ALL_0,
      style: ProjectNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.heading != null)
            Container(
              padding: ProjectEdgeInsets.HORIZONTAL_25
                  .add(ProjectEdgeInsets.LEFT_10)
                  .add(ProjectEdgeInsets.VERTICAL_15),
              color: ProjectColors.SECONDARY_LIGHT,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.heading,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: ProjectColors.PRIMARY_DARK),
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
          // ProjectSizedBoxes.HEIGHT_10,
          if (widget.tray != null) widget.tray,
        ],
      ),
    );
  }
}
