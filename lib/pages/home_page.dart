import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//data structure for todays List

  List todayHabitList = [
    // habit name and boolean for completion of habit
    ["Morning Run", false],
    ["Morning Walk", false],
  ];

// check box tapped

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
          itemCount: todayHabitList.length,
          itemBuilder: (context, index) => HabitTile(
              habitName: todayHabitList[index][0],
              habitCompleted: todayHabitList[index][1],
              onChanged: (value) => checkBoxTapped(value, index))),
    );
  }
}
