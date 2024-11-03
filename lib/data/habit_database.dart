// reference our box

// ignore_for_file: unnecessary_null_comparison, unused_local_variable, avoid_print

import 'package:habbit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataset = {};

  //create initial default data

  void createDefaultData() {
    todayHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("START_DATE", todayDateFormatted());
  }

  // load the existing data

  void loadData() {
    // Retrieve list from the box and ensure it’s correctly formatted
    List<dynamic>? savedList = _myBox.get("CURRENT_HABIT_LIST");
    if (savedList != null) {
      todayHabitList = savedList.map((item) {
        // Ensure each item is a list with a String and a bool
        if (item is List &&
            item.length == 2 &&
            item[0] is String &&
            item[1] is bool) {
          return item;
        } else {
          // Handle any data inconsistencies here
          return ["", false];
        }
      }).toList();
    }
  }

  //update the database

  void updateDataBase() {
    // update todays entry
    _myBox.put(todayDateFormatted(), todayHabitList);

    // update universal habit list in case it changed (new habit, edit habit, delete habit)

    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    // CALCULATE HIBIT COMPLETE % FOR EACH DAY

    calculatePercentage();

    //load heatmap

    loadHeatMap();
  }

  void calculatePercentage() {
    int countCompleted = 0;

    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = todayHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);
//kye: "PERCENTAGE_SUMMARYY_yyyymmdd"
//value:  string of 1dp number between 0.0-1.0 inclusive

    _myBox.put("PERCENTAGE_SUMMARY_${todayDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
//count the number of days to load

    int daysInBetween = DateTime.now().difference(startDate).inDays;

//go from start date to today and add each percentage to the database
//"PERCENTAGE_SUMMARY_yyyymmdd" will be key in the database

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      double strengthAsPercent =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");

      // split the datetime up like below so it does not worry about hours/mins/secs etc.

      //year
      int year = startDate.add(Duration(days: i)).year;

      //month

      int month = startDate.add(Duration(days: i)).month;

      //day

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataset.addEntries(percentForEachDay.entries);
    }
  }
}
