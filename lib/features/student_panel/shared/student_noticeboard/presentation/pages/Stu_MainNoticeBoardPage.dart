import 'package:flutter/material.dart';

class Stu_MainNoticeBoardPage extends StatelessWidget {
  const Stu_MainNoticeBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Noticeboard"),
      ),
      body: const Center(
        child: Text(
          "Student Noticeboard Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
