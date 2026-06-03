import 'package:flutter/material.dart';
import 'package:xo/player_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'player_screen',
      routes: {
        'home_screen': (context) => const HomeScreen(),
        'player_screen': (context) => const PlayerScreen(),
      },
    );
  }
}