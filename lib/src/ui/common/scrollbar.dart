import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';

///
/// Neumorphic Custom Scroll bar with drag functionality
///
/// @params heightScrollThumb         the height of the scrollbar
/// @params paddingDelta              the padding space from top and bottom (default 10.0)
/// @params child                     the list to be scrolled
/// @params controller                the scroll controller associated with the list passed inside the child
///

enum SCROLL_BAR_TYPE {
  LIGHT,
  DARK,
}

class ProjectDraggableScrollbar extends StatefulWidget {
  final double heightScrollThumb;
  final double paddingDelta;
  final Widget child;
  final ScrollController controller;
  final SCROLL_BAR_TYPE type;

  const ProjectDraggableScrollbar({
    this.heightScrollThumb: 40.0,
    @required this.child,
    @required this.controller,
    this.paddingDelta: 10.0,
    this.type: SCROLL_BAR_TYPE.LIGHT,
  }) : super();

  @override
  _ProjectDraggableScrollbarState createState() =>
      new _ProjectDraggableScrollbarState();
}

class _ProjectDraggableScrollbarState extends State<ProjectDraggableScrollbar> {
  //this counts offset for scroll thumb in Vertical axis
  double _barOffset;
  //this counts offset for list in Vertical axis
  double _viewOffset;
  //variable to track when scrollbar is dragged
  bool _isDragInProcess;

  @override
  void initState() {
    super.initState();
    _barOffset = widget.paddingDelta;
    _viewOffset = 0.0;
    _isDragInProcess = false;
  }

  //if list takes 300.0 pixels of height on screen and scrollthumb height is 40.0
  //then max bar offset is 260.0
  double get barMaxScrollExtent =>
      context.size.height - widget.heightScrollThumb;
  double get barMinScrollExtent => 0.0;

  //this is usually length (in pixels) of list
  //if list has 1000 items of 100.0 pixels each, maxScrollExtent is 100,000.0 pixels
  double get viewMaxScrollExtent => widget.controller.position.maxScrollExtent;
  //this is usually 0.0
  double get viewMinScrollExtent => widget.controller.position.minScrollExtent;

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    // proportion
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  double getBarDelta(
    double scrollViewDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    // proportion
    return scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isDragInProcess = true;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      _isDragInProcess = false;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _barOffset += details.delta.dy;

      if (_barOffset < barMinScrollExtent + widget.paddingDelta) {
        _barOffset = barMinScrollExtent + widget.paddingDelta;
      }
      if (_barOffset > barMaxScrollExtent - widget.paddingDelta) {
        _barOffset = barMaxScrollExtent - widget.paddingDelta;
      }

      double viewDelta = getScrollViewDelta(
          details.delta.dy, barMaxScrollExtent, viewMaxScrollExtent);

      _viewOffset = widget.controller.position.pixels + viewDelta;
      if (_viewOffset < widget.controller.position.minScrollExtent) {
        _viewOffset = widget.controller.position.minScrollExtent;
      }
      if (_viewOffset > viewMaxScrollExtent) {
        _viewOffset = viewMaxScrollExtent;
      }
      widget.controller.jumpTo(_viewOffset);
    });
  }

  //this function process events when scroll controller changes it's position
  //by scrollController.jumpTo or scrollController.animateTo functions.
  //It can be when user scrolls, drags scrollbar (see line 139)
  //or any other manipulation with scrollController outside this widget
  changePosition(ScrollNotification notification) {
    //if notification was fired when user drags we don't need to update scrollThumb position
    if (_isDragInProcess) {
      return;
    }

    setState(() {
      if (notification is ScrollUpdateNotification) {
        _barOffset += getBarDelta(
          notification.scrollDelta,
          barMaxScrollExtent,
          viewMaxScrollExtent,
        );

        if (_barOffset < barMinScrollExtent + widget.paddingDelta) {
          _barOffset = barMinScrollExtent + widget.paddingDelta;
        }
        if (_barOffset > barMaxScrollExtent - widget.paddingDelta) {
          _barOffset = barMaxScrollExtent - widget.paddingDelta;
        }

        _viewOffset += notification.scrollDelta;
        if (_viewOffset < widget.controller.position.minScrollExtent) {
          _viewOffset = widget.controller.position.minScrollExtent;
        }
        if (_viewOffset > viewMaxScrollExtent) {
          _viewOffset = viewMaxScrollExtent;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        changePosition(notification);
        return true;
      },
      child: new Stack(
        children: <Widget>[
          widget.child,
          GestureDetector(
            //we've add functions for onVerticalDragStart and onVerticalDragEnd
            //to track when dragging starts and finishes
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(
                top: _barOffset,
                right: 10.0,
              ),
              child: _buildScrollThumb(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollThumb() {
    return ProjectNeumorphic(
      padding: ProjectEdgeInsets.ALL_0,
      style: ProjectNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius: BorderRadius.all(ProjectBorderRadius.CIRCULAR_12),
        shape: NEUMORPHIC_SHAPE.FLAT,
        depth: ProjectNeumorphicTheme.DEPTH_5,
        intensity: ProjectNeumorphicTheme.INTENSITY_MAX,
        lightSource: LIGHT_SOURCE.TOP_LEFT,
        color: _colorMap[widget.type][_colorType.BG],
        shadowLightColor: _colorMap[widget.type][_colorType.SHADOW_LIGHT],
        shadowDarkColor: _colorMap[widget.type][_colorType.SHADOW_DARK],
      ),
      child: Container(
        height: widget.heightScrollThumb,
        width: 8.0,
      ),
    );
  }
}

enum _colorType {
  BG,
  SHADOW_LIGHT,
  SHADOW_DARK,
}

Map<SCROLL_BAR_TYPE, Map<_colorType, Color>> _colorMap = {
  SCROLL_BAR_TYPE.LIGHT: {
    _colorType.BG: ProjectColors.DEFAULT,
    _colorType.SHADOW_LIGHT: ProjectNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
    _colorType.SHADOW_DARK: ProjectNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
  },
  SCROLL_BAR_TYPE.DARK: {
    _colorType.BG: ProjectColors.PRIMARY_DARK,
    _colorType.SHADOW_LIGHT: ProjectNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
    _colorType.SHADOW_DARK: ProjectNeumorphicTheme.DARK_SHADOW_DARK_THEME,
  },
};
