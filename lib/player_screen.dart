import 'package:flutter/material.dart';
import 'package:xo/home_screen.dart';

// ─────────────────────────────────────────────
// Data Model — holds both player names
// passed to HomeScreen via navigation arguments
// ─────────────────────────────────────────────
class XoGameArgs {
  final String playerXName;
  final String playerOName;

  XoGameArgs({required this.playerXName, required this.playerOName});
}

// ─────────────────────────────────────────────
// PlayerScreen — first screen the user sees
// collects player names before starting the game
// ─────────────────────────────────────────────
class PlayerScreen extends StatefulWidget {
  static const String routeName = 'player_screen';

  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // ── Controllers ───────────────────────────
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  // ── Cleanup ───────────────────────────────
  // always dispose controllers to free memory
  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  // ── Navigation ────────────────────────────
  // validates names then navigates to the game screen
  void _startGame() {
    final String player1 = _player1Controller.text.trim();
    final String player2 = _player2Controller.text.trim();

    // make sure both names are filled before starting
    if (player1.isEmpty || player2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both player names"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // pass names to HomeScreen via XoGameArgs
    Navigator.of(context).pushNamed(
      HomeScreen.routeName,
      arguments: XoGameArgs(
        playerXName: player1,
        playerOName: player2,
      ),
    );
  }

  // ─────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,

      // ── App Bar ───────────────────────────
      appBar: AppBar(
        title: const Text(
          "XO GAME",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ─────────────────────────
            const Text(
              "Enter Player Names",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // ── Player 1 Field ────────────────
            TextField(
              controller: _player1Controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Player 1 Name (X)",
                labelStyle: const TextStyle(color: Colors.red),
                prefixIcon: const Icon(Icons.person, color: Colors.red),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Player 2 Field ────────────────
            TextField(
              controller: _player2Controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Player 2 Name (O)",
                labelStyle: const TextStyle(color: Colors.blue),
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Start Button ──────────────────
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Let's Play 🎮",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}