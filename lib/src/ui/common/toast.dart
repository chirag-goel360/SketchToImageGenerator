import 'package:humangenerator/src/localisation.dart';
import 'package:humangenerator/src/utils/border_radius.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:flutter/material.dart';

enum TOAST_TYPE {
  SUCCESS,
  ERROR,
}

Map<TOAST_TYPE, Color> _bgColorMap = {
  TOAST_TYPE.SUCCESS: ProjectColors.SUCCESS_DARK,
  TOAST_TYPE.ERROR: ProjectColors.ERROR_DARK,
};

Map<TOAST_TYPE, IconData> _iconMap = {
  TOAST_TYPE.SUCCESS: Icons.check_circle,
  TOAST_TYPE.ERROR: Icons.error,
};

void showProjectToast(
  BuildContext context, {
  String messageCode,
  TOAST_TYPE type: TOAST_TYPE.SUCCESS,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // if dialog and snackbar are opened at the same time, then its own dismiss will not work
  Future.delayed(Duration(seconds: 2), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(ProjectBorderRadius.CIRCULAR_12)),
      content: Row(
        children: <Widget>[
          Icon(
            _iconMap[type],
            color: ProjectColors.DEFAULT,
            size: 18,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              AppLocalization.of(context).translate(messageCode),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: ProjectColors.DEFAULT,
                  ),
            ),
          ),
        ],
      ),
      backgroundColor: _bgColorMap[type],
    ),
  );
}
