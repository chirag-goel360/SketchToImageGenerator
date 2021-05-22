import 'package:flutter/material.dart';
import 'package:humangenerator/src/ui/common/safe_area.dart';
import 'package:humangenerator/src/ui/screens/drawer.dart';
import 'package:humangenerator/src/ui/screens/shoe_conversion/shoe_to_image_consumer.dart';
import 'package:humangenerator/src/utils/colors.dart';

class ShoeImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProjectDrawer(),
      backgroundColor: ProjectColors.SECONDARY_LIGHT,
       body: ProjectSafeArea(
          child: ShoeConversionConsumer()
        ),
    );
  }
}