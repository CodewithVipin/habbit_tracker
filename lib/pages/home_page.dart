import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: const [
          //habit tiles
          HabitTile(
            habitName: "Morning Run",
          ),
          HabitTile(
            habitName: "Daily Walk",
          ),
        ],
      ),
    );
  }
}
