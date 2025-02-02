import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatefulWidget {
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
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          //setting Options
          SlidableAction(
            onPressed: widget.settingTapped,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(12),
          ),

          // delete Options
          //setting Options
          SlidableAction(
            onPressed: widget.deleteTapped,
            backgroundColor: Colors.red.shade400,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ]),
        // startActionPane: ,
        child: GestureDetector(
          onTap: () {
            widget.onChanged!(!widget.habitCompleted);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: widget.habitCompleted
                    ? Colors.green.withValues(alpha: 0.5)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Checkbox(
                  value: widget.habitCompleted,
                  onChanged: widget.onChanged,
                  activeColor: Colors.tealAccent, // Visible color when checked
                  checkColor:
                      Colors.black, // Dark color for checkmark in dark theme
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors
                          .tealAccent; // Color when checkbox is checked
                    }
                    return Colors.white70; // Default color when not checked
                  }),
                ),
                Expanded(
                    child: Text(
                  widget.habitName,
                  style: TextStyle(
                      color:
                          widget.habitCompleted ? Colors.white : Colors.black),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
