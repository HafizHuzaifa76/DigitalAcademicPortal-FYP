
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/TimeTable.dart';
import '../controllers/TimeTableController.dart';
import 'EditTimeTableEntryForm.dart';

class TimeTableWidget extends StatefulWidget {
  List<TimeTableEntry> timetableEntries;
  final String sectionName;
  final String semester;
  final String deptName;
  final Function(String) onDelete; // Callback for delete
  final Function(TimeTableEntry) onEdit; // Callback for edit

  TimeTableWidget({
    super.key,
    required this.timetableEntries,
    required this.onDelete,
    required this.onEdit,
    required this.sectionName,
    required this.semester,
    required this.deptName,
  });

  @override
  _TimeTableWidgetState createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  final TimeTableController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New TimeTable')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
          onPressed: () {
            controller.addTimeTable(widget.timetableEntries, widget.deptName, widget.semester);
          },
        child: const Icon(Icons.check_circle_outline, color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.sectionName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),

            Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor: WidgetStateColor.resolveWith((states) => Get.theme.primaryColor.withValues(alpha: 0.9)),
                    border: TableBorder.all(color: Colors.black26),
                    columns: const [
                      DataColumn(label: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Course Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Teacher', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Room', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Time Slot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Day', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Section', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                    ],
                    rows: widget.timetableEntries.map((entry) {
                      return DataRow(cells: [
                        DataCell(Text(entry.courseCode)),
                        DataCell(Text(entry.courseName)),
                        DataCell(Text(entry.teacherName)),
                        DataCell(Text(entry.room)),
                        DataCell(Text(entry.timeSlot)),
                        DataCell(Text(entry.day)),
                        DataCell(Text(entry.section)),
                        DataCell(Text(entry.semester)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editEntry(context, entry),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, entry.id),
                            )
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Confirm Delete Dialog
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                widget.onDelete(id); // Call the delete function
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Edit Bottom Sheet
  void _editEntry(BuildContext context, TimeTableEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return EditTimeTableEntryForm(
          entry: entry,
          onSave: widget.onEdit,
        );
      },
    );
  }
}

