import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';
import 'package:habbit_tracker/components/my_fab.dart';
import 'package:habbit_tracker/components/my_alert_box.dart';

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
      builder: (context) => MyAlertBox(
        hintText: "Ener Habit Name",
        controller: _newHabitNameController,
        onCancel: cancelDialogueBox,
        onSave: onSaveNewHabit,
      ),
    );
  }

  //save New Habbit

  void onSaveNewHabit() {
    setState(() {
      todayHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  //Cancel new Habit

  void cancelDialogueBox() {
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

//save existing habit

  void saveExistingHabit(int index) {
    setState(() {
      todayHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  // open habit settings to edit

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) => MyAlertBox(
            hintText: todayHabitList[index][0],
            controller: _newHabitNameController,
            onCancel: cancelDialogueBox,
            onSave: () => saveExistingHabit(index)));
  }

  //delete habit

  void deleteHabit(int index) {
    setState(() {
      todayHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: todayHabitList.isNotEmpty
          ? ListView.builder(
              itemCount: todayHabitList.length,
              itemBuilder: (context, index) => HabitTile(
                  settingTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                  habitName: todayHabitList[index][0],
                  habitCompleted: todayHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index)))
          : const Center(
              child: Text(
                "No Habit Found",
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
