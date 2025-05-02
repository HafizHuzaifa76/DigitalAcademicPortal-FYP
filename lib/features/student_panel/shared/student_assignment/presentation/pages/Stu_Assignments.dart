import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  List<String> courses = [
    'Software Engineering',
    'Operating Systems',
    'Artificial Intelligence & ML',
    'Cloud Computing',
  ];
  String? selectedCourse;

  final Map<String, List<Map<String, String>>> courseAssignments = {
    'Software Engineering': [
      {
        'title': 'Use Case Diagrams',
        'dueDate': '2025-05-01',
        'instructions': 'Design use case diagrams for a library system.',
        'status': 'Not Uploaded',
      },
      {
        'title': 'Agile Model',
        'dueDate': '2025-05-07',
        'instructions': 'Write a report on Agile methodology.',
        'status': 'Not Uploaded',
      },
    ],
    'Operating Systems': [
      {
        'title': 'Memory Management',
        'dueDate': '2025-05-03',
        'instructions': 'Simulate paging in C.',
        'status': 'Not Uploaded',
      },
      {
        'title': 'Process Scheduling',
        'dueDate': '2025-05-10',
        'instructions': 'Implement FCFS and Round Robin in Java.',
        'status': 'Not Uploaded',
      },
    ],
    'Artificial Intelligence & ML': [
      {
        'title': 'Linear Regression',
        'dueDate': '2025-05-05',
        'instructions': 'Implement linear regression in Python.',
        'status': 'Not Uploaded',
      },
      {
        'title': 'Search Algorithms',
        'dueDate': '2025-05-12',
        'instructions': 'Implement BFS and DFS.',
        'status': 'Not Uploaded',
      },
    ],
    'Cloud Computing': [
      {
        'title': 'Cloud Models',
        'dueDate': '2025-05-06',
        'instructions': 'Compare IaaS, PaaS, and SaaS.',
        'status': 'Not Uploaded',
      },
      {
        'title': 'AWS Lab',
        'dueDate': '2025-05-15',
        'instructions': 'Set up EC2 and S3 on AWS Free Tier.',
        'status': 'Not Uploaded',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentAssignments = selectedCourse != null
        ? courseAssignments[selectedCourse] ?? []
        : [];

    return Scaffold(
      appBar: AppBar(title: Text('Pending Assignments')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedCourse,
              hint: Text('Select Course'),
              onChanged: (newValue) {
                setState(() {
                  selectedCourse = newValue;
                });
              },
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Pending Assignments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: currentAssignments.isEmpty
                  ? Center(
                child: Text(
                  'No course selected or no assignments available.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: currentAssignments.length,
                itemBuilder: (context, index) {
                  final assignment = currentAssignments[index];
                  return Card(
                    color: Color(0xFF2C5D3B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                        },
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text('Title:', style: _labelStyle()),
                              Text(assignment['title']!,
                                  style: _valueStyle()),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Due Date:', style: _labelStyle()),
                              Text(assignment['dueDate']!,
                                  style: _valueStyle()),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Instructions:', style: _labelStyle()),
                              Text(assignment['instructions']!,
                                  style: _valueStyle()),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Status:', style: _labelStyle()),
                              Text(assignment['status']!,
                                  style: _valueStyle()),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 12.0),
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _uploadAssignment(index),
                                  icon: Icon(Icons.upload_file),
                                  label: Text('Upload Assignment'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() =>
      TextStyle(color: Colors.white70, fontWeight: FontWeight.w600);
  TextStyle _valueStyle() =>
      TextStyle(color: Colors.white, fontSize: 16);

  Future<void> _uploadAssignment(int index) async {
    if (selectedCourse == null) return;
    final assignmentList = courseAssignments[selectedCourse]!;
    final dueDate = DateTime.parse(assignmentList[index]['dueDate']!);
    final now = DateTime.now();

    if (now.isAfter(dueDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Due date passed! Upload not allowed.')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        assignmentList[index]['status'] = 'Uploaded';
      });

      print('Selected file: ${result.files.single.name}');
    }
  }
}
