import 'package:flutter/material.dart';

class Stu_AllCourses extends StatelessWidget {
  const Stu_AllCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
      ),
      body: const Center(
        child: Text(
          "Courses Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
