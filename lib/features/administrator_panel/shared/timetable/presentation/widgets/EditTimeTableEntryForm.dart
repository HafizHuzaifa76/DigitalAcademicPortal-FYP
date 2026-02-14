
import 'package:flutter/material.dart';

import '../../../../../../shared/domain/entities/TimeTable.dart';

class EditTimeTableEntryForm extends StatefulWidget {
  final TimeTableEntry entry;
  final Function(TimeTableEntry) onSave;

  const EditTimeTableEntryForm({Key? key, required this.entry, required this.onSave}) : super(key: key);

  @override
  _EditTimeTableEntryFormState createState() => _EditTimeTableEntryFormState();
}

class _EditTimeTableEntryFormState extends State<EditTimeTableEntryForm> {
  late String room;
  late String day;
  late String timeSlot;

  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  final List<String> timeSlots = [
    "8:00 - 9:30 AM", "9:30 - 11:00 AM", "11:00 - 12:30 PM", "12:30 - 2:00 PM",
    "2:00 - 3:30 PM", "3:30 - 5:00 PM", "5:00 - 6:30 PM", "6:30 - 8:00 PM", "8:00 - 9:30 PM"
  ];

  @override
  void initState() {
    super.initState();
    room = widget.entry.room;
    day = widget.entry.day;
    timeSlot = widget.entry.timeSlot;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Edit Timetable Entry", style: Theme.of(context).appBarTheme.titleTextStyle),
          const SizedBox(height: 10),

          // Course Name (Readonly)
          TextFormField(
            initialValue: widget.entry.courseName,
            decoration: const InputDecoration(labelText: "Course Name"),
            readOnly: true,
          ),

          // Teacher Name (Readonly)
          TextFormField(
            initialValue: widget.entry.teacherName,
            decoration: const InputDecoration(labelText: "Teacher Name"),
            readOnly: true,
          ),

          // Room (Editable)
          TextFormField(
            initialValue: room,
            decoration: const InputDecoration(labelText: "Room"),
            onChanged: (value) => room = value,
          ),

          // Day (Dropdown)
          DropdownButtonFormField<String>(
            value: day,
            decoration: const InputDecoration(labelText: "Day"),
            items: days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (value) => setState(() => day = value!),
          ),

          // Time Slot (Dropdown)
          DropdownButtonFormField<String>(
            value: timeSlot,
            decoration: const InputDecoration(labelText: "Time Slot"),
            items: timeSlots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (value) => setState(() => timeSlot = value!),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSave(TimeTableEntry(
                id: widget.entry.id,
                courseCode: widget.entry.courseCode,
                courseName: widget.entry.courseName,
                teacherName: widget.entry.teacherName,
                teacherCNIC: widget.entry.teacherCNIC,
                room: room,
                timeSlot: timeSlot,
                day: day,
                section: widget.entry.section,
                semester: widget.entry.semester,
              ));
              Navigator.pop(context);
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
