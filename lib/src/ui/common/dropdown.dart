import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/ui/common/dotted_separator.dart';
import 'package:humangenerator/src/ui/common/scrollbar.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/key_value.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic_button.dart';

///
/// Neumorphic theme dropdown
///
/// @params options                 KeyValueDisableWithExtraDetails type options list
/// @params selectedKey
/// @params disabled
/// @params placeholder
/// @params label
/// @params errorMessage
///
/// usage:
/// ```
///                 ShipsyDropdown(
///                  options: [
///                    KeyValueWithExtraDetails('1', 'Value 1'),
///                    KeyValueWithExtraDetails('2', 'Value 2'),
///                    KeyValueWithExtraDetails('3', 'Value 3'),
///                  ],
///                  selectedKey: selectedValue,
///                  disabled: true,
///                  onSelect: (newVal) {
///                    setState(() {
///                      selectedValue = newVal;
///                    });
///                  },
///                 placeholder: 'Search this',
///                );
/// ```
///

enum DROPDOWN_TYPE {
  LIGHT,
  DARK,
}

enum _COLOR_KEYS {
  TEXT,
  BG,
  SHADOW_LIGHT,
  SHADOW_DARK,
}

Map<DROPDOWN_TYPE, Map<_COLOR_KEYS, Color>> _colorsMap = {
  DROPDOWN_TYPE.DARK: {
    _COLOR_KEYS.TEXT: ShipsyColors.DEFAULT,
    _COLOR_KEYS.BG: ShipsyColors.PRIMARY_DARK,
    _COLOR_KEYS.SHADOW_LIGHT: ShipsyNeumorphicTheme.LIGHT_SHADOW_DARK_THEME,
    _COLOR_KEYS.SHADOW_DARK: ShipsyNeumorphicTheme.DARK_SHADOW_DARK_THEME,
  },
  DROPDOWN_TYPE.LIGHT: {
    _COLOR_KEYS.TEXT: ShipsyColors.PRIMARY_DARK,
    _COLOR_KEYS.BG: ShipsyColors.DEFAULT,
    _COLOR_KEYS.SHADOW_LIGHT: ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
    _COLOR_KEYS.SHADOW_DARK: ShipsyNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
  },
};

enum DROPDOWN_DIRECTION {
  UP,
  DOWN,
}

class ShipsyDropdown extends StatefulWidget {
  final List<KeyValueDisableWithExtraDetails> options;
  final KeyValueDisableWithExtraDetails selectedValue;
  final String label;
  final String errorMessage;
  final void Function(KeyValueDisableWithExtraDetails newSelectedValue)
      onSelect;
  final bool disabled;
  final String placeholder;
  final EdgeInsets margin;
  final Widget Function(
      BuildContext context,
      KeyValueDisableWithExtraDetails option,
      bool disabled,
      bool selected) buildDropdownItem;
  final DROPDOWN_TYPE type;
  final bool arrowVisible;
  final DROPDOWN_DIRECTION direction;

  const ShipsyDropdown({
    Key key,
    @required this.options,
    @required this.selectedValue,
    @required this.placeholder,
    this.onSelect,
    this.disabled: false,
    this.label,
    this.errorMessage,
    this.margin: EdgeInsets.zero,
    this.buildDropdownItem,
    this.type: DROPDOWN_TYPE.LIGHT,
    this.arrowVisible: true,
    this.direction: DROPDOWN_DIRECTION.DOWN,
  }) : super(key: key);

  @override
  _ShipsyDropdownState createState() => _ShipsyDropdownState();
}

class _ShipsyDropdownState extends State<ShipsyDropdown> {
  /// states for overlay
  OverlayEntry _overlayEntry;
  OverlayEntry _overlayBackdropEntry;
  bool _visible = false;
  final LayerLink _layerLink = LayerLink();
  final ScrollController scrollController = ScrollController();
  GlobalKey _dropdownKey = GlobalKey();

  void _visibilityChanged() {
    if (_visible) {
      _overlayBackdropEntry = _createBackdropOverlayEntry();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayBackdropEntry);
      Overlay.of(context).insert(_overlayEntry);

      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
    } else {
      _overlayEntry.remove();
      _overlayBackdropEntry.remove();
    }
  }

  OverlayEntry _createBackdropOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () {
            _toggleVisibility();
          },
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _dropdownKey.currentContext.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: _renderList(),
          offset: Offset(0,
              widget.direction == DROPDOWN_DIRECTION.DOWN ? size.height : -140),
        ),
      ),
    );
  }

  Widget _renderListChildren() {
    return ListView.builder(
      controller: scrollController,
      padding: ShipsyEdgeInsets.ALL_0,
      itemCount: widget.options.length,
      itemBuilder: (BuildContext context, int index) {
        return _ShipsyDropDownMenuItem(
          onPressed: () {
            _toggleVisibility();
            if (widget.onSelect != null) {
              widget.onSelect(widget.options[index]);
            }
          },
          selected: widget.selectedValue != null &&
              widget.selectedValue.key == widget.options[index].key,
          data: widget.options[index],
          disabled: widget.options[index].disabled,
          buildDropdownItem: widget.buildDropdownItem,
          type: widget.type,
        );
      },
    );
  }

  Widget _renderList() {
    double paddingHeight = 5.0;
    Widget child = ShipsyNeumorphic(
      padding: ShipsyEdgeInsets.BOTTOM_10,
      style: ShipsyNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius: BorderRadius.all(ShipsyBorderRadius.CIRCULAR_12),
        shape: NEUMORPHIC_SHAPE.FLAT,
        depth: ShipsyNeumorphicTheme.DEPTH_3,
        intensity: ShipsyNeumorphicTheme.INTENSITY_0P85,
        lightSource: LIGHT_SOURCE.TOP_LEFT,
        color: _colorsMap[widget.type][_COLOR_KEYS.BG],
        shadowLightColor: _colorsMap[widget.type][_COLOR_KEYS.SHADOW_LIGHT],
        shadowDarkColor: _colorsMap[widget.type][_COLOR_KEYS.SHADOW_DARK],
      ),
      child: Container(
        height: 120.0,
        child: _renderListChildren(),
      ),
    );
    return Column(
      children: <Widget>[
        SizedBox(
          height: paddingHeight,
          child: Container(
            height: paddingHeight,
            color: Colors.transparent,
          ),
        ),
        widget.options.length > 2
            ? ShipsyDraggableScrollbar(
                type: widget.type == DROPDOWN_TYPE.LIGHT
                    ? SCROLL_BAR_TYPE.LIGHT
                    : SCROLL_BAR_TYPE.DARK,
                heightScrollThumb: (widget.options.length < 20
                    ? (120.0 / widget.options.length).floor() + 5.0
                    : 25),
                controller: scrollController,
                child: child,
              )
            : child,
      ],
    );
  }

  void _toggleVisibility() {
    setState(() {
      _visible = !_visible;
      _visibilityChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown = CompositedTransformTarget(
      link: _layerLink,
      child: ShipsyNeumorphicButton(
        margin: widget.label == null && widget.errorMessage == null
            ? widget.margin
            : EdgeInsets.zero,
        key: _dropdownKey,
        padding:
            ShipsyEdgeInsets.HORIZONTAL_15.add(ShipsyEdgeInsets.VERTICAL_10),
        onClick: widget.disabled ? null : _toggleVisibility,
        style: ShipsyNeumorphicStyle(
          boxShape: BOX_SHAPE.ROUND_RECT,
          borderRadius: BorderRadius.all(ShipsyBorderRadius.CIRCULAR_12),
          shape: NEUMORPHIC_SHAPE.FLAT,
          depth: ShipsyNeumorphicTheme.DEPTH_3,
          intensity: ShipsyNeumorphicTheme.INTENSITY_0P85,
          lightSource: LIGHT_SOURCE.TOP_LEFT,
          color: widget.disabled
              ? ShipsyColors.DISABLED_LIGHT
              : _colorsMap[widget.type][_COLOR_KEYS.BG],
          shadowLightColor: _colorsMap[widget.type][_COLOR_KEYS.SHADOW_LIGHT],
          shadowDarkColor: _colorsMap[widget.type][_COLOR_KEYS.SHADOW_DARK],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.selectedValue == null
                  ? widget.placeholder
                  : AppLocalization.of(context)
                      .translate(widget.selectedValue.value),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: widget.disabled
                        ? ShipsyColors.DISABLED_DARK
                        : _colorsMap[widget.type][_COLOR_KEYS.TEXT],
                  ),
            ),
            widget.arrowVisible
                ? Icon(
                    _visible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24.0,
                    color: widget.disabled
                        ? ShipsyColors.DISABLED_DARK
                        : _colorsMap[widget.type][_COLOR_KEYS.TEXT],
                  )
                : Container(),
          ],
        ),
      ),
    );

    List<Widget> finalWidget = [];

    if (widget.label != null) {
      finalWidget.add(
        Padding(
          padding: ShipsyEdgeInsets.LEFT_15.add(ShipsyEdgeInsets.BOTTOM_15),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: ShipsyColors.SECONDARY_DARK,
                ),
          ),
        ),
      );
    }

    finalWidget.add(dropdown);

    if (widget.errorMessage != null) {
      finalWidget.add(Padding(
        padding: ShipsyEdgeInsets.LEFT_15.add(ShipsyEdgeInsets.TOP_10),
        child: Text(
          widget.errorMessage,
          style: Theme.of(context).textTheme.overline.copyWith(
                color: ShipsyColors.ERROR_DARK,
              ),
        ),
      ));
    }

    return finalWidget.length == 1
        ? dropdown
        : Padding(
            padding: widget.margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: finalWidget,
            ),
          );
  }
}

class _ShipsyDropDownMenuItem extends StatelessWidget {
  final bool selected;
  final KeyValueDisableWithExtraDetails data;
  final Function onPressed;
  final bool disabled;
  final Widget Function(
      BuildContext context,
      KeyValueDisableWithExtraDetails option,
      bool disabled,
      bool selected) buildDropdownItem;
  final DROPDOWN_TYPE type;

  const _ShipsyDropDownMenuItem({
    Key key,
    @required this.selected,
    @required this.data,
    @required this.onPressed,
    this.disabled: false,
    this.buildDropdownItem,
    this.type: DROPDOWN_TYPE.LIGHT,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tab = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildDropdownItem != null
            ? buildDropdownItem(context, data, disabled, selected)
            : Text(
                AppLocalization.of(context).translate(data.value?.toString()),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: disabled
                          ? ShipsyColors.DISABLED_DARK
                          : (selected
                              ? ShipsyColors.DEFAULT
                              : _colorsMap[type][_COLOR_KEYS.TEXT]),
                    ),
              ),
        SizedBox(
          height: 15.0,
        ),
        DottedSeparator(),
      ],
    );

    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: disabled ? null : onPressed,
        child: selected
            ? ShipsyNeumorphic(
                padding:
                    ShipsyEdgeInsets.HORIZONTAL_20.add(ShipsyEdgeInsets.TOP_15),
                style: ShipsyNeumorphicStyle(
                  depth: ShipsyNeumorphicTheme.EMBOSS_DEPTH_3,
                  intensity: ShipsyNeumorphicTheme.INTENSITY_0P85,
                  color: ShipsyColors.PRIMARY_LIGHT,
                  shadowLightColorEmboss: Colors.transparent,
                  shadowDarkColorEmboss: _colorsMap[type]
                      [_COLOR_KEYS.SHADOW_DARK],
                ),
                child: tab,
              )
            : Container(
                padding:
                    ShipsyEdgeInsets.HORIZONTAL_20.add(ShipsyEdgeInsets.TOP_15),
                child: tab,
              ),
      ),
    );
  }
}
