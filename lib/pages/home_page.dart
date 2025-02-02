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
  late String todayDate; // Store today's date as a class variable

  @override
  void initState() {
    super.initState();

    todayDate = DateTime.now().toString().split(' ')[0]; // Get today's date

    // ✅ Debugging: Print stored START_DATE

    // Ensure LAST_UPDATED_DATE is valid
    String lastUpdatedDate = _myBox.get("LAST_UPDATED_DATE", defaultValue: "");
    if (lastUpdatedDate.isEmpty ||
        !RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(lastUpdatedDate)) {
      lastUpdatedDate = todayDate; // Reset if invalid
      _myBox.put("LAST_UPDATED_DATE", todayDate);
    }

    // Ensure START_DATE is valid
    // Ensure START_DATE is valid
    String? startDate = _myBox.get("START_DATE");
    if (startDate == null ||
        !RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(startDate)) {
      _myBox.put("START_DATE", todayDate); // Set today's date if invalid
    }

    // ✅ Debugging: Print stored START_DATE after fix

    // Reset habits for a new day
    if (lastUpdatedDate != todayDate) {
      db.resetTodayHabits();
      _myBox.put("LAST_UPDATED_DATE", todayDate);
    }

    // Load or create habit data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDataBase();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value ?? false;
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
      backgroundColor: Colors.black, // Dark mode background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        elevation: 0.0,
        title: const Text(
          "Build Habits, Build Success!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900], // Dark AppBar
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[850], // Dark drawer
        child: const Center(
          child: Text(
            "Designed by Vipin Kumar Maurya",
            style: TextStyle(color: Colors.white70), // Light drawer text
          ),
        ),
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: SingleChildScrollView(
        // Ensure everything is scrollable
        child: Column(
          children: [
            // MonthSummary takes up the required space before the ListView
            MonthSummary(
              datesets: db.heatMapDataset,
              startDate: _myBox.get("START_DATE")?.toString() ??
                  todayDate, // ✅ Fixed null issue
            ),
            // Wrap ListView inside Expanded to ensure it takes up remaining space
            SizedBox(
              height: 400, // You can adjust this height based on your design
              child: ListView.builder(
                itemCount: db.todayHabitList.length,
                itemBuilder: (context, index) => HabitTile(
                  settingTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                  habitName: db.todayHabitList[index][0] ?? "Unnamed Habit",
                  habitCompleted: db.todayHabitList[index][1] ?? false,
                  onChanged: (value) => checkBoxTapped(value, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
