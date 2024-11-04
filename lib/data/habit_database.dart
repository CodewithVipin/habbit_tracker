import 'package:habbit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

class HabitDatabase {
  // Define the Hive box inside the class
  final _myBox = Hive.box("Habit_Database");

  List todayHabitList = [];
  Map<DateTime, int> heatMapDataset = {};

  // Create initial default data
  void createDefaultData() {
    todayHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("START_DATE", todayDateFormatted());
  }

  // Load existing data
  void loadData() {
    List<dynamic>? savedList = _myBox.get("CURRENT_HABIT_LIST");
    if (savedList != null) {
      todayHabitList = savedList.map((item) {
        if (item is List &&
            item.length == 2 &&
            item[0] is String &&
            item[1] is bool) {
          return item;
        } else {
          return ["", false];
        }
      }).toList();
    }
  }

  // Update the database with current data
  void updateDataBase() {
    // Update today’s entry
    _myBox.put(todayDateFormatted(), todayHabitList);

    // Update universal habit list if it changed
    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    // Calculate completion percentage for each day
    calculatePercentage();

    // Load heatmap data
    loadHeatMap();
  }

  // Calculate completion percentage
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
    _myBox.put("PERCENTAGE_SUMMARY_${todayDateFormatted()}", percent);
  }

  // Load heat map data
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      double strengthAsPercent =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataset.addEntries(percentForEachDay.entries);
    }
  }

  // Reset today's habit completion status for a new day
  void resetTodayHabits() {
    for (int i = 0; i < todayHabitList.length; i++) {
      todayHabitList[i][1] =
          false; // Set each habit's completion status to false
    }
    updateDataBase(); // Save the reset list to Hive
  }
}
