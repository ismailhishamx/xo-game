import 'package:flutter/material.dart';
import 'package:xo/card_board.dart';
import 'package:xo/player_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // The board: 9 empty strings, one for each cell
  List<String> boardState = ["", "", "", "", "", "", "", "", ""];

  // Counts total moves made (used to know whose turn it is)
  int counter = 0;

  // Scores for each player
  int player1Score = 0;
  int player2Score = 0;

  // Called when a player taps a cell
  void onButtonAction(int index) {
    // If the cell is already taken, do nothing
    if (boardState[index].isNotEmpty) return;

    setState(() {
      // Even counter = Player 1 (X), Odd counter = Player 2 (O)
      if (counter % 2 == 0) {
        boardState[index] = 'X';
      } else {
        boardState[index] = 'O';
      }
      counter++; // Move to the next turn
    });

    // Check if someone won after this move
    String? winner = checkWinner();
    if (winner != null) {
      // Update the score for the winner
      setState(() {
        if (winner == 'X') player1Score++;
        if (winner == 'O') player2Score++;
      });

      // Show a dialog announcing the winner
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.all(24),
          title: Text(
            "$winner Wins! 🎉",
            style: TextStyle(color: winner == 'X' ? Colors.red : Colors.blue, fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: winner == 'X' ? Colors.red : Colors.blue),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  resetGame(); // Reset the board
                },
                child: Text("Play Again", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      );
    }
    // If all 9 cells are filled and no winner → it's a draw
    else if (counter == 9) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.all(24),
          backgroundColor: Colors.grey[900],
          title: Text(
            "It's a Draw 🤝",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  resetGame(); // Reset the board
                },
                child: Text("Play Again", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Checks all possible winning combinations
  String? checkWinner() {
    // All 8 ways to win: 3 rows, 3 columns, 2 diagonals
    List<List<int>> winners = [
      [0, 1, 2], // Top row
      [3, 4, 5], // Middle row
      [6, 7, 8], // Bottom row
      [0, 3, 6], // Left column
      [1, 4, 7], // Middle column
      [2, 5, 8], // Right column
      [0, 4, 8], // Diagonal top-left to bottom-right
      [2, 4, 6], // Diagonal top-right to bottom-left
    ];

    for (var combo in winners) {
      String a = boardState[combo[0]];
      String b = boardState[combo[1]];
      String c = boardState[combo[2]];

      // If all 3 cells match and are not empty → we have a winner
      if (a == b && b == c && a.isNotEmpty) return a;
    }

    // No winner found
    return null;
  }

  // bool checkWinner2(String symbol){
  //
  // }

  // Resets the board for a new round (keeps the scores)
  void resetGame() {
    setState(() {
      boardState = ["", "", "", "", "", "", "", "", ""];
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    XoGameArgs args = ModalRoute.of(context)!.settings.arguments as XoGameArgs;
    return Scaffold(
      backgroundColor: Colors.black,

      // Top app bar with title and refresh button
      appBar: AppBar(
        title: Text(
          "XO GAME",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => resetGame(),
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [
          // ── Score Section ──────────────────────────────
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Player X score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${args.playerXName} (X)",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "($player1Score)",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                // Player O score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${args.playerOName}  (O)",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "($player2Score)",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Board Row 1: cells 0, 1, 2 ────────────────
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardBoard(text: boardState[0], index: 0, onButtonCall: onButtonAction),
                CardBoard(text: boardState[1], index: 1, onButtonCall: onButtonAction),
                CardBoard(text: boardState[2], index: 2, onButtonCall: onButtonAction),
              ],
            ),
          ),

          // ── Board Row 2: cells 3, 4, 5 ────────────────
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardBoard(text: boardState[3], index: 3, onButtonCall: onButtonAction),
                CardBoard(text: boardState[4], index: 4, onButtonCall: onButtonAction),
                CardBoard(text: boardState[5], index: 5, onButtonCall: onButtonAction),
              ],
            ),
          ),

          // ── Board Row 3: cells 6, 7, 8 ────────────────
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardBoard(text: boardState[6], index: 6, onButtonCall: onButtonAction),
                CardBoard(text: boardState[7], index: 7, onButtonCall: onButtonAction),
                CardBoard(text: boardState[8], index: 8, onButtonCall: onButtonAction),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
