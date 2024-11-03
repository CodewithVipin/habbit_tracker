import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final void Function(BuildContext)? settingTapped;
  final void Function(BuildContext)? deleteTapped;
  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          //setting Options
          SlidableAction(
            onPressed: settingTapped,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(12),
          ),

          // delete Options
          //setting Options
          SlidableAction(
            onPressed: deleteTapped,
            backgroundColor: Colors.red.shade400,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ]),
        // startActionPane: ,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Checkbox(
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    // If the checkbox is checked, return the desired color
                    if (states.contains(WidgetState.selected)) {
                      return Colors
                          .grey.shade800; // Change this to your desired color
                    }
                    // Return a default color for unchecked state
                    return Colors.grey
                        .shade500; // Change this to your desired unchecked color
                  },
                ),
                value: habitCompleted,
                onChanged: onChanged,
              ),
              Expanded(
                  child: Text(
                habitName,
                style: TextStyle(color: Colors.grey[500]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
