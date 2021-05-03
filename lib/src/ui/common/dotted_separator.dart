import 'package:humangenerator/src/utils/colors.dart';
import 'package:flutter/material.dart';

class DottedSeparator extends StatelessWidget {
  final double height;
  final Color color;
  final Widget prefix;
  final Widget suffix;

  const DottedSeparator({
    this.height = 0.75,
    this.color = ShipsyColors.DISABLED_DARK,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        int dashCount = (boxWidth / (2 * dashWidth)).floor();
        if (prefix != null) dashCount--;
        if (suffix != null) dashCount--;
        List<Widget> list = List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        });
        if (prefix != null) list.insert(0, prefix);
        if (suffix != null) list.add(suffix);
        return Flex(
          children: list,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
