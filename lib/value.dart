import 'package:flutter/material.dart';

enum Tetromino { L, Z, N, I, O, S, T, J }

enum Direction { down, left, right }

int numRow = 10;
int numCol = 15;

const Map<Tetromino, Color> tetrominoColor = {
  Tetromino.I: Color(0xFFFFA500),
  Tetromino.J: Color(0xFF4CB119),
  Tetromino.L: Color(0xFF44359B),
  Tetromino.N: Color(0xFFA53D76),
  Tetromino.O: Color(0xFFB4131C),
  Tetromino.S: Color(0xFF7EBCE0),
  Tetromino.T: Color(0xFFB53DC0),
  Tetromino.Z: Color(0xFF8F696F),
};
