import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper_app/bomb.dart';
import 'package:minesweeper_app/numberbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberInEachRow = 9;
  int numberOfSquares = 9 * 9;
  var squareStatus = []; // [bombs around, revealed = true/false]
  List<int> bombLocation = [];
  bool bombsRevealed = false;
  int timeCount = 0;

  @override
  void initState() {
    super.initState();
    generateBombs();
    initSquares();
    scanBombs();
    timeCounter();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      bombLocation = [];
      squareStatus = [];
      timeCount = 0;
      generateBombs();
      initSquares();
      scanBombs();
    });
  }

  void generateBombs() {
    var rng = Random();

    for (var i = 0; i < rng.nextInt(5) + 9; i++) {
      bombLocation.add(rng.nextInt(80));
    }
  }

  void initSquares() {
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
  }

  void revealBoxNumbers(int index) {
    // reveal current if it is a number: 1,2,3 etc
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }

    // if BOX is 0
    else if (squareStatus[index][0] == 0) {
      setState(() {
        // current box
        squareStatus[index][1] = true;

        // left box
        if (index % numberInEachRow != 0) {
          // if next box isn't revealed yet and it is a 0
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          // reveal left box
          squareStatus[index - 1][1] = true;
        }

        // top box
        if (index >= numberInEachRow) {
          // if next box isn't revealed yet and it is a 0
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          // reveal left box
          squareStatus[index - numberInEachRow][1] = true;
        }

        // right box
        if (index % numberInEachRow != numberInEachRow - 1) {
          // if next box isn't revealed yet and it is a 0
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          // reveal left box
          squareStatus[index + 1][1] = true;
        }

        // bottom box
        if (index < numberOfSquares - numberInEachRow) {
          // if next box isn't revealed yet and it is a 0
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          // reveal left box
          squareStatus[index + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      // check square to the left
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      // check square to the top left
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the top
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the top right
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the right
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      // check square to the bottom right
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the bottom
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      // check square to the bottom left
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Center(
            child: Text(
              'YOU LOST!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              child: const Icon(Icons.refresh),
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Center(
            child: Text(
              'NICE JOB, YOU WIN!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              child: const Icon(Icons.refresh),
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  void timeCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timeCount++;
      });
    });
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());
    return parsedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bombLocation.length.toString(),
                        style: const TextStyle(fontSize: 40),
                      ),
                      const Text('B O M B'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 40,
                    ),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatedTime(timeCount),
                        style: const TextStyle(fontSize: 40),
                      ),
                      const Text('T I M E'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInEachRow,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return MyBomb(
                    revealed: bombsRevealed,
                    function: () {
                      playerLost();
                      setState(() {
                        bombsRevealed = true;
                      });
                    },
                  );
                } else {
                  return MyNumberBox(
                    child: squareStatus[index][0],
                    revealed: squareStatus[index][1],
                    function: () {
                      revealBoxNumbers(index);
                      checkWinner();
                    },
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('C R E A T E D B Y I G K A M'),
          )
        ],
      ),
    );
  }
}
