import 'package:flutter/material.dart';

class TeachersGradeScreen extends StatefulWidget {
  const TeachersGradeScreen({super.key});

  @override
  State<TeachersGradeScreen> createState() => _TeachersGradeScreenState();
}

class _TeachersGradeScreenState extends State<TeachersGradeScreen> {
  String selectedSubject = 'CS-4201-Data Structures';
  String selectedStudent = 'Ahmed Khan';

  final List<String> students = [
    'Ahmed Khan', 'Ali Raza', 'Fatima Noor', 'Hassan Ali', 'Sara Sheikh',
    'Zainab Ali', 'Usman Tariq', 'Ayesha Khan', 'Bilal Ahmad', 'Hina Malik',
    'Rizwan Jutt', 'Mariam Shah', 'Asad Mehmood', 'Komal Niazi', 'Tariq Bashir',
    'Areeba Siddiq', 'Saad Qureshi', 'Lubna Akhtar', 'Imran Aslam', 'Sana Mir',
    'Talha Zubair', 'Mehwish Nawaz', 'Kashif Raza', 'Nida Ahmed', 'Fawad Hussain',
  ];

  final List<String> subjects = [
    'CS-4201-Data Structures',
    'CS-4202-OOP',
    'CS-4203-DBMS',
    'CS-4204-OS',
    'CS-4205-Entrepreneurship',
  ];

  final Map<String, List<Map<String, dynamic>>> gradeSections = {
    'Quizzes': [
      {'title': 'Quiz 1', 'total': 10, 'obtained': 0},
    ],
    'Assignments': [
      {'title': 'Assignment 1', 'total': 20, 'obtained': 0},
    ],
    'Presentations': [
      {'title': 'Presentation 1', 'total': 20, 'obtained': 0},
    ],
    'Midterm': [
      {'title': 'Midterm', 'total': 30, 'obtained': 0},
    ],
    'Final': [
      {'title': 'Final Exam', 'total': 50, 'obtained': 0},
    ],
  };

  void _editEntry(String section, int index) {
    final entry = gradeSections[section]![index];
    final titleController = TextEditingController(text: entry['title']);
    final totalController = TextEditingController(text: entry['total'].toString());
    final obtainedController = TextEditingController(text: entry['obtained'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Grade Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: totalController, decoration: const InputDecoration(labelText: 'Total Marks'), keyboardType: TextInputType.number),
            TextField(controller: obtainedController, decoration: const InputDecoration(labelText: 'Obtained Marks'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                gradeSections[section]![index] = {
                  'title': titleController.text,
                  'total': int.tryParse(totalController.text) ?? 0,
                  'obtained': int.tryParse(obtainedController.text) ?? 0,
                };
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addEntry(String section) {
    final titleController = TextEditingController();
    final totalController = TextEditingController();
    final obtainedController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Grade Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: totalController, decoration: const InputDecoration(labelText: 'Total Marks'), keyboardType: TextInputType.number),
            TextField(controller: obtainedController, decoration: const InputDecoration(labelText: 'Obtained Marks'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                gradeSections[section]!.add({
                  'title': titleController.text,
                  'total': int.tryParse(totalController.text) ?? 0,
                  'obtained': int.tryParse(obtainedController.text) ?? 0,
                });
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalMarks = 0;
    int obtainedMarks = 0;

    gradeSections.forEach((_, entries) {
      for (var entry in entries) {
        totalMarks += entry['total'] as int;
        obtainedMarks += entry['obtained'] as int;
      }
    });

    double percentage = totalMarks > 0 ? (obtainedMarks / totalMarks) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Grading'),
        backgroundColor: const Color(0xFF00796B),
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedSubject,
              isExpanded: true,
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedSubject = val!),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedStudent,
              isExpanded: true,
              items: students.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedStudent = val!),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: gradeSections.entries.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(section.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _addEntry(section.key),
                          )
                        ],
                      ),
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Color(0xFFE0F2F1)),
                            children: [
                              Padding(padding: EdgeInsets.all(8), child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Obtained', style: TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          ...section.value.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var grade = entry.value;
                            return TableRow(
                              children: [
                                Padding(padding: const EdgeInsets.all(8), child: Text(grade['title'])),
                                Padding(padding: const EdgeInsets.all(8), child: Text('${grade['total']}')),
                                Padding(padding: const EdgeInsets.all(8), child: Text('${grade['obtained']}')),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      IconButton(onPressed: () => _editEntry(section.key, idx), icon: const Icon(Icons.edit, size: 20)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
            Text('Total: $totalMarks | Obtained: $obtainedMarks | Percentage: ${percentage.toStringAsFixed(2)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Grades saved successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save Grades', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}