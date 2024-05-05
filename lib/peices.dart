import 'package:flutter/material.dart';
import 'package:tetris/value.dart';

class Peices {
  Tetromino type;
  Peices({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColor[type] ?? const Color(0xFFFFFFFF);
  }

  void initializePeice() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.O:
        position = [-16, -15, -6, -5];
        break;
      case Tetromino.J:
        position = [-26, -16, -6, -7];
        break;
      case Tetromino.I:
        position = [-36, -26, -16, -6];
        break;
      case Tetromino.N:
        position = [-26, -16, -15, -5];
        break;
      case Tetromino.S:
        position = [-16, -15, -6, -7];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-17, -16, -15, -6];
        break;
    }
  }

  void movePeice(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += numRow;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
    }
  }
}
