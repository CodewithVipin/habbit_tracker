import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';
import 'package:habbit_tracker/components/my_fab.dart';
import 'package:habbit_tracker/components/new_habit_box.dart';

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
    ["Code App", false],
  ];

// check box tapped

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value!;
    });
  }

  //create a new habit

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    //show a dialogue box
    showDialog(
      context: context,
      builder: (context) => EnterNewHabitBox(
        controller: _newHabitNameController,
        onCancel: onCancelNewHabit,
        onSave: onSaveNewHabit,
      ),
    );
  }

  //save New Habbit

  void onSaveNewHabit() {
    setState(() {
      todayHabitList.add([_newHabitNameController.text, false]);
    });
    Navigator.pop(context);
  }

  //Cancel new Habit

  void onCancelNewHabit() {
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: ListView.builder(
          itemCount: todayHabitList.length,
          itemBuilder: (context, index) => HabitTile(
              habitName: todayHabitList[index][0],
              habitCompleted: todayHabitList[index][1],
              onChanged: (value) => checkBoxTapped(value, index))),
    );
  }
}
