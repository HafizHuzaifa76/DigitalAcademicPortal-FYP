import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassOverviewScreen extends StatelessWidget {
  final dynamic course;

  const ClassOverviewScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final students = [
      {'name': 'Ali Khan', 'rollNo': '2021-CS-001'},
      {'name': 'Fatima Ahmed', 'rollNo': '2021-CS-002'},
      {'name': 'Usman Ali', 'rollNo': '2021-CS-003'},
      {'name': 'Sana Malik', 'rollNo': '2021-CS-004'},
      {'name': 'Hassan Raza', 'rollNo': '2021-CS-005'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Class Overview - ${course.courseCode}'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Get.theme.primaryColor,
                child: Text(
                  student['name']!.split(' ').map((e) => e[0]).join(''),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(student['name']!),
              subtitle: Text('Roll No: ${student['rollNo']}'),
            ),
          );
        },
      ),
    );
  }
} 