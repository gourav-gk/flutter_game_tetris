import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final isGameOver;
  final reset;
  GameOver(this.isGameOver, this.reset);

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment(0.0, 0.0),
                  child: const Text(
                    'GAME OVER',
                    style: TextStyle(color: Colors.white, fontSize: 21.0),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: Text('Play Again'),
                    onPressed: reset,
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
