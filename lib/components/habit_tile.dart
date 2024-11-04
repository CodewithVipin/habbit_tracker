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
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
                activeColor: Colors.tealAccent, // Visible color when checked
                checkColor:
                    Colors.black, // Dark color for checkmark in dark theme
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.tealAccent; // Color when checkbox is checked
                  }
                  return Colors.white70; // Default color when not checked
                }),
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
