import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:humangenerator/dinogame/game/audio_manager.dart';
import 'package:humangenerator/dinogame/main_game.dart';
import 'package:humangenerator/src/routes.dart';
import 'package:humangenerator/src/utils/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humangenerator/src/localisation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    runApp(
      MyApp(),
    );
  } else {
    await Flame.util.fullScreen();
    await Flame.util.setLandscape();
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await AudioManager.instance
        .init(['8Bit Platformer Loop.wav', 'hurt7.wav', 'jump14.wav']);
    runApp(
      MyAppGame(),
    );
  }
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
        primaryColor: ProjectColors.PRIMARY_LIGHT,
        primaryColorDark: ProjectColors.PRIMARY_DARK,
        accentColor: ProjectColors.SECONDARY_DARK,
        errorColor: ProjectColors.ERROR_DARK,
        disabledColor: ProjectColors.DISABLED_LIGHT,
        backgroundColor: ProjectColors.DEFAULT,
        scaffoldBackgroundColor: ProjectColors.DEFAULT,
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
          bodyColor: ProjectColors.PRIMARY_DARK,
          displayColor: ProjectColors.PRIMARY_DARK,
        ),
      ),
      initialRoute: Routes.SPLASH,
      onGenerateRoute: ProjectRouter.generateRoute,
    );
    return app;
  }
}
