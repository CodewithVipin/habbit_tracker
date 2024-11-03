import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';
import 'package:habbit_tracker/components/month_summary.dart';
import 'package:habbit_tracker/components/my_fab.dart';
import 'package:habbit_tracker/components/my_alert_box.dart';
import 'package:habbit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("Habit_Database");
  HabitDatabase db = HabitDatabase();

  @override
  void initState() {
    super.initState();
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDataBase();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value!;
    });
    db.updateDataBase();
  }

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => MyAlertBox(
        hintText: "Enter Habit Name",
        controller: _newHabitNameController,
        onCancel: cancelDialogueBox,
        onSave: onSaveNewHabit,
      ),
    );
  }

  void onSaveNewHabit() {
    setState(() {
      db.todayHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDataBase();
  }

  void cancelDialogueBox() {
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDataBase();
  }

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) => MyAlertBox(
            hintText: db.todayHabitList[index][0],
            controller: _newHabitNameController,
            onCancel: cancelDialogueBox,
            onSave: () => saveExistingHabit(index)));
  }

  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        elevation: 0.0,
        title: Text(
          "Build Habits, Build Success!",
          style: TextStyle(color: Colors.grey[500]),
        ),
        backgroundColor: Colors.grey[900], // Darker AppBar
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[800],
        child: const Center(
          child: Text(
            "Designed by Vipin Kumar Maurya",
            style: TextStyle(color: Colors.white), // Light text for drawer
          ),
        ),
      ),
      backgroundColor: Colors.grey[850], // Darker background
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: Column(
        children: [
          // Monthly summary heat map
          MonthSummary(
            datesets: db.heatMapDataset,
            startDate: _myBox.get("START_DATE"),
          ),
          // Expanded widget to allow the list to take the remaining space and scroll
          Expanded(
            child: ListView.builder(
              itemCount: db.todayHabitList.length,
              itemBuilder: (context, index) => HabitTile(
                settingTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
                habitName: db.todayHabitList[index][0],
                habitCompleted: db.todayHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
