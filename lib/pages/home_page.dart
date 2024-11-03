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
//data structure for todays List

  final _myBox = Hive.box("Habit_Database");
  HabitDatabase db = HabitDatabase();
  @override
  void initState() {
// if there is no current habit list, then it is first time ever opening app
// then create default data

    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    // update database
    db.updateDataBase();

    super.initState();
  }

// check box tapped

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value!;
    });
    db.updateDataBase();
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
      db.todayHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDataBase();
  }

  //Cancel new Habit

  void cancelDialogueBox() {
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

//save existing habit

  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDataBase();
  }

  // open habit settings to edit

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) => MyAlertBox(
            hintText: db.todayHabitList[index][0],
            controller: _newHabitNameController,
            onCancel: cancelDialogueBox,
            onSave: () => saveExistingHabit(index)));
  }

  //delete habit

  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onPressed: createNewHabit,
        ),
        body: ListView(
          children: [
            //monthly summary
            MonthSummary(
                datesets: db.heatMapDataset,
                startDate: _myBox.get("START_DATE")),

            //list of habit

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: db.todayHabitList.length,
              itemBuilder: (context, index) => HabitTile(
                  settingTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                  habitName: db.todayHabitList[index][0],
                  habitCompleted: db.todayHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index)),
            ),
          ],
        ));
  }
}
