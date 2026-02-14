import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class TeacherAssignmentPortal extends StatefulWidget {
  const TeacherAssignmentPortal({super.key});

  @override
  State<TeacherAssignmentPortal> createState() => _TeacherAssignmentPortalState();
}

class _TeacherAssignmentPortalState extends State<TeacherAssignmentPortal> {
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _marksController = TextEditingController();
  DateTime? _dueDate;
  String? _uploadedFileName;

  List<Map<String, String>> previousAssignments = [
    {
      'title': 'Binary Trees',
      'dueDate': '2025-04-25',
      'marks': '20',
      'file': 'binary_tree_assignment.pdf',
    },
    {
      'title': 'Networking Models',
      'instructions': 'Write a report on OSI vs TCP/IP.',
      'dueDate': '2025-04-28',
      'marks': '15',
      'file': 'networking_assignment.pdf',
    },
  ];

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  void _submitAssignment() {
    if (_titleController.text.isEmpty ||
        _instructionsController.text.isEmpty ||
        _dueDate == null ||
        _marksController.text.isEmpty ||
        _uploadedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload file")),
      );
      return;
    }

    setState(() {
      previousAssignments.add({
        'title': _titleController.text,
        'instructions': _instructionsController.text,
        'dueDate': DateFormat('yyyy-MM-dd').format(_dueDate!),
        'marks': _marksController.text,
        'file': _uploadedFileName!,
      });

      _titleController.clear();
      _instructionsController.clear();
      _marksController.clear();
      _uploadedFileName = null;
      _dueDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF2C5D3B);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teacher Assignment Portal'),
          bottom: const TabBar(
            labelColor: Colors.white,                // Selected tab text/icon color
            unselectedLabelColor: Colors.white70,    // Unselected tab text/icon color
            indicatorColor: Colors.white,            // Optional: underline color
            tabs: const [
              Tab(text: "New Assignment", icon: Icon(Icons.assignment)),
              Tab(text: "Previous Assignments", icon: Icon(Icons.history)),
            ],
          )

        ),
        body: TabBarView(
          children: [
            // New Assignment Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Make New Assignment",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: green)),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      _buildTableRow("Title", TextField(controller: _titleController)),
                      _buildTableRow("Instructions", TextField(controller: _instructionsController, maxLines: 2)),
                      _buildTableRow("Due Date", TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2026),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dueDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          _dueDate != null
                              ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                              : "Select Due Date",
                          style: TextStyle(color: green),
                        ),
                      )),
                      _buildTableRow("Total Marks", TextField(controller: _marksController, keyboardType: TextInputType.number)),
                      _buildTableRow("Upload PDF", TextButton.icon(
                        onPressed: _pickFile,
                        icon: Icon(Icons.upload_file, color: green),
                        label: Text(_uploadedFileName ?? "Choose File", style: TextStyle(color: green)),
                      )),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _submitAssignment,
                      icon: const Icon(Icons.send),
                      label: const Text("Post Assignment",style: TextStyle(color:Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Previous Assignments View
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: previousAssignments.map((assignment) => Card(
                  color: green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        _infoRow("Title", assignment['title']!),
                        _infoRow("Due Date", assignment['dueDate']!),
                        _infoRow("Marks", assignment['marks']!),
                        _infoRow("Instructions", assignment['instructions']!),
                        _infoRow("PDF File", assignment['file']!),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, Widget field) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: field,
        ),
      ],
    );
  }

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('$label:', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
