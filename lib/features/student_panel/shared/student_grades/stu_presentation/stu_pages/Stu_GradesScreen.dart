import 'package:flutter/material.dart';

class Stu_GradesScreen extends StatelessWidget {
  const Stu_GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Grades"),
      ),
      body: const Center(
        child: Text(
          "Student Grades Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
