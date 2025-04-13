import 'package:flutter/material.dart';

class Stu_TimeTablePage extends StatelessWidget {
  const Stu_TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
      ),
      body: const Center(
        child: Text(
          "Timetable Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
