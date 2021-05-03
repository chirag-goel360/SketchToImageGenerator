import 'dart:async';
import 'dart:core';
import 'package:humangenerator/src/ui/common/neumorphic/neumorphic.dart';
import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/ui/common/dotted_separator.dart';
import 'package:humangenerator/src/ui/common/loading_indicator.dart';
import 'package:humangenerator/src/ui/common/scrollbar.dart';
import 'package:humangenerator/src/ui/common/textfield.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:humangenerator/src/utils/edge_insets.dart';
import 'package:humangenerator/src/utils/key_value.dart';
import 'package:humangenerator/src/utils/neumorphic_theme.dart';
import 'package:humangenerator/src/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShipsySearchSelect extends StatefulWidget {
  final String placeholder;
  final bool autoFocus;
  final int maxLength;
  final TextInputType keyboardType;
  final bool enableInteractiveSelection;
  final bool enabled;
  final bool isEmptyQueryAllowed;
  final Widget suffix;
  final Future<List<KeyValueDisableWithExtraDetails>> Function(String query)
      searchFunction;
  final List<KeyValueDisableWithExtraDetails> options;
  final KeyValueDisableWithExtraDetails selectedValue;
  final void Function(KeyValueDisableWithExtraDetails option) handleSelect;
  final String label;
  final String errorMessage;
  final EdgeInsets margin;
  final Widget Function(BuildContext context,
      KeyValueDisableWithExtraDetails option, bool selected) buildDropdownItem;
  final bool clearAllowed;

  const ShipsySearchSelect(
      {Key key,
      @required this.placeholder,
      @required this.handleSelect,
      this.selectedValue,
      this.maxLength,
      this.autoFocus: false,
      this.keyboardType,
      this.enableInteractiveSelection: true,
      this.enabled: true,
      this.isEmptyQueryAllowed: true,
      this.suffix,
      this.searchFunction,
      this.options: const [],
      this.errorMessage,
      this.label,
      this.margin: EdgeInsets.zero,
      this.buildDropdownItem,
      this.clearAllowed})
      : super(key: key);

  @override
  _ShipsySearchSelectState createState() => _ShipsySearchSelectState();
}

class _ShipsySearchSelectState extends State<ShipsySearchSelect> {
  List<KeyValueDisableWithExtraDetails> _dropdownOptions = [];
  bool loading = false;

  /// states for overlay
  OverlayEntry _overlayEntry;
  OverlayEntry _overlayBackdropEntry;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  /// states for debounce
  final _searchQuery = TextEditingController();
  Timer _debounce;

  GlobalKey _dropdownKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  void _markOverlayForRebuild() {
    if (_overlayEntry != null) {
      _overlayEntry.markNeedsBuild();
    }
  }

  void _handleSearch(String query) async {
    if (!_focusNode.hasFocus) return;
    if (_searchQuery.text == widget.selectedValue?.value &&
        _dropdownOptions.length > 0) return;
    List<KeyValueDisableWithExtraDetails> options;
    if (!widget.isEmptyQueryAllowed && query.length == 0) {
      return;
    }
    if (widget.searchFunction != null) {
      _markOverlayForRebuild();
      setState(() {
        loading = true;
      });
      options = await widget.searchFunction(query);
    } else {
      options =
          widget.options.where((KeyValueDisableWithExtraDetails searchOption) {
        return searchOption.value
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase());
      }).toList();
    }
    _markOverlayForRebuild();
    setState(() {
      _dropdownOptions = options;
      loading = false;
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      this._handleSearch(_searchQuery.text);
    });
  }

  void _focusChanged() {
    if (_focusNode.hasFocus) {
      _overlayBackdropEntry = _createBackdropOverlayEntry();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayBackdropEntry);
      Overlay.of(context).insert(_overlayEntry);
    } else {
      if (_overlayEntry != null && _overlayBackdropEntry != null) {
        _overlayEntry.remove();
        _overlayBackdropEntry.remove();
        _overlayEntry = null;
        _overlayBackdropEntry = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusChanged);
    _searchQuery.addListener(_onSearchChanged);
    if (widget.options.length > 0) {
      setState(() {
        _dropdownOptions = widget.options;
      });
    } else if (widget.selectedValue != null) {
      _searchQuery.text = widget.selectedValue.value;
      setState(() {
        _dropdownOptions = [widget.selectedValue];
      });
    }
  }

  @override
  void didUpdateWidget(ShipsySearchSelect oldWidget) {
    if (oldWidget.selectedValue?.key != widget.selectedValue?.key) {
      _focusNode.unfocus();
      if (widget.selectedValue == null)
        _searchQuery.clear();
      else
        _searchQuery.text = widget.selectedValue.value;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _markOverlayForRebuild();
    });
    super.didUpdateWidget(oldWidget);
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
            _focusNode.unfocus();
          },
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _dropdownKey.currentContext.findRenderObject();
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: this
              ._renderList(size.height, Theme.of(context).textTheme.bodyText2),
        ),
      ),
    );
  }

  Widget _renderListChildren(TextStyle textStyle) {
    if (loading) {
      return Center(
        child: Container(
          height: 20.0,
          width: 20.0,
          child: CenterLoadingIndicator(),
        ),
      );
    } else if (!loading && _dropdownOptions.length == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.inbox,
            size: 28.0,
            color: ShipsyColors.DISABLED_DARK,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            AppLocalization.of(context).translate(Strings.NO_OPTIONS),
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
              color: ShipsyColors.DISABLED_DARK,
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        controller: scrollController,
        padding: ShipsyEdgeInsets.ALL_0,
        itemCount: _dropdownOptions.length,
        itemBuilder: (BuildContext context, int index) {
          return SearchMenuItem(
            onPressed: () {
              if (widget.selectedValue?.key == _dropdownOptions[index].key) {
                _focusNode.unfocus();
                if (_searchQuery.text != widget.selectedValue.value)
                  _searchQuery.text = widget.selectedValue.value;
              }
              widget.handleSelect(_dropdownOptions[index]);
            },
            selected: widget.selectedValue?.key == _dropdownOptions[index].key,
            data: _dropdownOptions[index],
            buildDropdownItem: widget.buildDropdownItem,
          );
        },
      );
    }
  }

  Widget _renderList(double height, TextStyle textStyle) {
    double paddingHeight = height + 5.0;
    EdgeInsets margin = widget.label == null && widget.errorMessage == null
        ? widget.margin
        : EdgeInsets.zero;
    Widget child = ShipsyNeumorphic(
      margin: EdgeInsets.only(left: margin.left, right: margin.right),
      padding: ShipsyEdgeInsets.TOP_0.add(ShipsyEdgeInsets.BOTTOM_10),
      style: ShipsyNeumorphicStyle(
        boxShape: BOX_SHAPE.ROUND_RECT,
        borderRadius: BorderRadius.all(ShipsyBorderRadius.CIRCULAR_12),
        depth: ShipsyNeumorphicTheme.EMBOSS_DEPTH_5,
        intensity: ShipsyNeumorphicTheme.INTENSITY_0P85,
        lightSource: LIGHT_SOURCE.TOP_LEFT,
        color: ShipsyColors.DEFAULT,
        shadowLightColorEmboss: ShipsyNeumorphicTheme.LIGHT_SHADOW_LIGHT_THEME,
        shadowDarkColorEmboss: ShipsyNeumorphicTheme.DARK_SHADOW_LIGHT_THEME,
      ),
      child: Container(
        height: 120.0,
        child: this._renderListChildren(textStyle),
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
        _dropdownOptions.length > 2 && !loading
            ? ShipsyDraggableScrollbar(
                heightScrollThumb: (_dropdownOptions.length < 20
                    ? (120.0 / _dropdownOptions.length).floor() + 5.0
                    : 25.0),
                controller: scrollController,
                child: child,
              )
            : child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = CompositedTransformTarget(
      link: this._layerLink,
      child: ShipsyTextField(
        margin: widget.label == null && widget.errorMessage == null
            ? widget.margin
            : EdgeInsets.zero,
        suffixIcon: widget.suffix,
        key: _dropdownKey,
        autoFocus: widget.autoFocus,
        controller: _searchQuery,
        focusNode: this._focusNode,
        placeholder: widget.placeholder,
        clearAllowed: widget.clearAllowed,
        prefixIcon: Icon(
          Icons.search,
          size: 22.0,
          color: ShipsyColors.PRIMARY_DARK,
        ),
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        enableInteractiveSelection: widget.enableInteractiveSelection,
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

  @override
  void dispose() {
    _searchQuery.removeListener(this._onSearchChanged);
    _searchQuery.dispose();
    if (_debounce != null) {
      _debounce.cancel();
    }

    _focusNode.removeListener(this._focusChanged);
    _focusNode.dispose();
    super.dispose();
  }
}

class SearchMenuItem extends StatelessWidget {
  final bool selected;
  final KeyValueDisableWithExtraDetails data;
  final Function onPressed;
  final Widget Function(BuildContext context,
      KeyValueDisableWithExtraDetails option, bool selected) buildDropdownItem;

  SearchMenuItem({
    Key key,
    @required this.selected,
    @required this.data,
    @required this.onPressed,
    this.buildDropdownItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: this.onPressed,
        child: Container(
          padding: ShipsyEdgeInsets.HORIZONTAL_20.add(ShipsyEdgeInsets.TOP_15),
          color: this.selected ? ShipsyColors.PRIMARY_LIGHT : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildDropdownItem != null
                  ? buildDropdownItem(context, data, selected)
                  : Text(
                      this.data.value,
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: this.selected
                                ? ShipsyColors.DEFAULT
                                : ShipsyColors.PRIMARY_DARK,
                          ),
                    ),
              SizedBox(
                height: 15.0,
              ),
              DottedSeparator(),
            ],
          ),
        ),
      ),
    );
  }
}
