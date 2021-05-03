import 'package:flutter/material.dart';
import 'package:humangenerator/src/routes.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humangenerator/src/localisation.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      supportedLocales: SUPPORTED_LANGUAGES.entries
          .map((MapEntry<String, String> e) => Locale(e.key, e.value))
          .toList(),
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: ShipsyColors.PRIMARY_LIGHT,
        primaryColorDark: ShipsyColors.PRIMARY_DARK,
        accentColor: ShipsyColors.SECONDARY_DARK,
        errorColor: ShipsyColors.ERROR_DARK,
        disabledColor: ShipsyColors.DISABLED_LIGHT,
        backgroundColor: ShipsyColors.DEFAULT,
        scaffoldBackgroundColor: ShipsyColors.DEFAULT,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.w900, letterSpacing: 0),
          headline2: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.w900, letterSpacing: 0),
          headline3: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          headline4: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          headline5: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          headline6: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          subtitle1: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          subtitle2: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          // will be used for labels (for form fields)
          bodyText1: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w700, letterSpacing: 0),
          // will be used for default body text
          bodyText2: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.normal, letterSpacing: 0),
          // Smallest text or caption
          caption: TextStyle(
              fontSize: 11.0, fontWeight: FontWeight.normal, letterSpacing: 0),
          // form field error messages or any other smaller text
          overline: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.1),
          button: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w700, letterSpacing: 0),
        ).apply(
          bodyColor: ShipsyColors.PRIMARY_DARK,
          displayColor: ShipsyColors.PRIMARY_DARK,
        ),
      ),
      initialRoute: Routes.SPLASH,
      onGenerateRoute: ShipsyRouter.generateRoute,
    );

    return  app
    ;
  }
}
