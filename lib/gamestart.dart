import 'package:flutter/material.dart';

class GameStart extends StatelessWidget {
  final hasGameSatrted;
  GameStart(this.hasGameSatrted);
  @override
  Widget build(BuildContext context) {
    return hasGameSatrted
        ? Container()
        : Container(
            alignment: Alignment(0.0, 0.0),
            child: const Text(
              'Tap To Play',
              style: TextStyle(color: Colors.white, fontSize: 21.0),
            ),
          );
  }
}
