import 'package:flutter/material.dart';
import '../game/game.dart';

class GamePlay extends StatelessWidget {
  final DinoGame _dinoGame = DinoGame();
  GamePlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dinoGame.widget,
    );
  }
}
