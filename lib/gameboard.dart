import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/gameover.dart';
import 'package:tetris/gamestart.dart';
import 'package:tetris/peices.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/value.dart';

// gamebaord

List<List<Tetromino?>> gameboard =
    List.generate(numCol, (i) => List.generate(numRow, (j) => null));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Peices currentPeice = Peices(type: Tetromino.L);
  bool isGameOver = false;
  int score = 0;
  bool hasGameStarted = false;

  void startGame() {
    if (!hasGameStarted) {
      hasGameStarted = true;
      currentPeice.initializePeice();
      Duration frameRate = Duration(milliseconds: 400);
      gameLoop(frameRate);
    }
  }

  void gameLoop(frame) {
    Timer.periodic(frame, (timer) {
      setState(() {
        // check landing
        checkLanding();

        // move down
        currentPeice.movePeice(Direction.down);

        tileMatch();

        if (isGameOver) {
          timer.cancel();
          //gameOverDailoge();
        }
      });
    });
  }

  void resetGame() {
    gameboard =
        List.generate(numCol, (i) => List.generate(numRow, (j) => null));
    isGameOver = false;
    hasGameStarted = false;
    score = 0;
    startGame();
  }

  bool collisionDetection(Direction direction) {
    for (int i = 0; i < currentPeice.position.length; i++) {
      int row = (currentPeice.position[i] / numRow).floor();
      int col = currentPeice.position[i] % numRow;

      // ajust row and col based on direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      //check out of bound peice

      if (col < 0 || col >= numRow || row >= numCol) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (collisionDetection(Direction.down) || checkLanded()) {
      for (int i = 0; i < currentPeice.position.length; i++) {
        int row = (currentPeice.position[i] / numRow).floor();
        int col = currentPeice.position[i] % numRow;
        if (row >= 0 && col >= 0) {
          gameboard[row][col] = currentPeice.type;
        }

        if (row <= 0) {
          isGameOver = true;
        }
      }

      createNewPeice();
    }
  }

  bool checkLanded() {
    // loop through each position of the current piece
    for (int i = 0; i < currentPeice.position.length; i++) {
      int row = (currentPeice.position[i] / numRow).floor();
      int col = currentPeice.position[i] % numRow;

      // check if the cell below is already occupied
      if (row + 1 < numCol && row >= 0 && gameboard[row + 1][col] != null) {
        return true; // collision with a landed piece
      }
    }

    return false; // no collision with landed pieces
  }

  void createNewPeice() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPeice = Peices(type: randomType);
    currentPeice.initializePeice();
  }

  void moveLeft() {
    if (!collisionDetection(Direction.left)) {
      setState(() {
        currentPeice.movePeice(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!collisionDetection(Direction.right)) {
      setState(() {
        currentPeice.movePeice(Direction.right);
      });
    }
  }

  void rotate() {
    int mincol = numRow;
    int minrow = numCol;
    for (int i = 0; i < currentPeice.position.length; i++) {
      int row = (currentPeice.position[i] / numRow).floor();
      int col = currentPeice.position[i] % numRow;
      if (row < minrow) {
        minrow = row;
      }
      if (col < mincol) {
        mincol = col;
      }
    }
    List<int> temp = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int num = ((minrow + i) * 10) + (mincol + j);
        if (currentPeice.position.contains(num)) {
          temp.add(((minrow + j) * 10) + (mincol + i));
        }
      }
    }
    currentPeice.position.replaceRange(0, 3, temp);
  }

  void tileMatch() {
    for (int r = numCol - 1; r >= 0; r--) {
      bool rowFull = true;
      for (int c = 0; c < numRow; c++) {
        if (gameboard[r][c] == null) {
          rowFull = false;
          break;
        }
      }
      if (rowFull) {
        for (int i = r; i > 0; i--) {
          gameboard[i] = List.from(gameboard[i - 1]);
        }
        //gameboard[0] = List.generate(r, (index) => null);
        setState(() {
          score = score + 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          itemCount: numCol * numRow,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: numRow),
                          itemBuilder: ((context, index) {
                            int row = (index / numRow).floor();
                            int col = (index % numRow);
                            if (currentPeice.position.contains(index)) {
                              return Pixel(color: currentPeice.color);
                            } else if (gameboard[row][col] != null) {
                              final Tetromino? tetrominoType =
                                  gameboard[row][col];
                              return Pixel(
                                  color: tetrominoColor[tetrominoType]);
                            } else {
                              return Pixel(color: Colors.grey[900]);
                            }
                          })),
                    ),
                    Text(
                      'Score:$score',
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: moveLeft,
                            icon: Icon(Icons.arrow_left),
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: rotate,
                            icon: Icon(Icons.rotate_right),
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: moveRight,
                            icon: Icon(Icons.arrow_right),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                GameStart(hasGameStarted),
                GameOver(isGameOver, resetGame)
              ],
            ),
          )),
    );
  }
}
