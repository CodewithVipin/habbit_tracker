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

    String? lastUpdatedDate = _myBox.get("LAST_UPDATED_DATE");
    String todayDate = DateTime.now().toString().split(' ')[0];

    if (lastUpdatedDate != todayDate) {
      db.resetTodayHabits();
      _myBox.put("LAST_UPDATED_DATE", todayDate);
    }

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
        onSave: () => saveExistingHabit(index),
      ),
    );
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
      backgroundColor: Colors.black, // Set main background for dark mode
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Build Habits, Build Success!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900], // Dark AppBar background
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[850], // Dark drawer background
        child: const Center(
          child: Text(
            "Designed by Vipin Kumar Maurya",
            style: TextStyle(color: Colors.white70), // Light drawer text color
          ),
        ),
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: Column(
        children: [
          MonthSummary(
            datesets: db.heatMapDataset,
            startDate: _myBox.get("START_DATE"),
          ),
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
