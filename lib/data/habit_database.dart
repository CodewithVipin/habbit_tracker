// reference our box

import 'package:hive/hive.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];

  //create initial default data

  void createDefaultData() {
    List todayHabitList = [
      ["Run", false],
      ["Read", false],
    ];
  }

  // load the existing data

  void loadData() {}

  //update the database

  void updateDataBase() {}
}
