import 'package:flutter/material.dart';

class Tch_AllCourses extends StatelessWidget {
  const Tch_AllCourses({super.key});

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
