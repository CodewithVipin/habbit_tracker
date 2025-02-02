import 'package:hive/hive.dart';
import 'package:habbit_tracker/datetime/date_time.dart';

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
    _myBox.put("START_DATE", todayDateFormatted()); // Store today's date
  }

  // Load existing data
  void loadData() {
    List<dynamic> savedList = _myBox.get("CURRENT_HABIT_LIST") ?? [];

    todayHabitList = savedList.map((item) {
      if (item is List &&
          item.length == 2 &&
          item[0] is String &&
          item[1] is bool) {
        return item;
      } else {
        return ["", false]; // Default value for invalid data
      }
    }).toList();
  }

  // Update the database with current data
  void updateDataBase() {
    _myBox.put(todayDateFormatted(), todayHabitList); // Update today's habits
    _myBox.put("CURRENT_HABIT_LIST", todayHabitList); // Update the habit list
    calculatePercentage(); // Calculate and store the completion percentage
    loadHeatMap(); // Update heatmap data
  }

  // Calculate completion percentage
  void calculatePercentage() {
    int countCompleted = 0;
    for (var habit in todayHabitList) {
      if (habit[1] == true) {
        countCompleted++;
      }
    }

    String percent = todayHabitList.isEmpty
        ? "0.0"
        : (countCompleted / todayHabitList.length)
            .clamp(0, 1)
            .toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todayDateFormatted()}",
        percent); // Store the percentage
  }

  // Load heatmap data
  void loadHeatMap() {
    DateTime startDate =
        createDateTimeObject(_myBox.get("START_DATE") ?? todayDateFormatted());

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToString(startDate.add(Duration(days: i)));

      // Safely parse percentage values and fallback to a default value if invalid
      double strengthAsPercent = double.tryParse(
              _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd")?.toString() ??
                  "0.0") ??
          0.0;

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataset
          .addEntries(percentForEachDay.entries); // Update heatmap dataset
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

  // Safely create a DateTime object from a string, with error handling
  DateTime createDateTimeObject(String dateStr) {
    try {
      return DateTime.parse(dateStr); // Parse the date if the format is correct
    } catch (e) {
      // Log errors for debugging
      return DateTime.now(); // Fallback to current date if parsing fails
    }
  }
}
