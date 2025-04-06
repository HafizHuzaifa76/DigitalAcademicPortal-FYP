import 'package:flutter/material.dart';

class Stu_Attendance extends StatelessWidget {
  const Stu_Attendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: const Center(
        child: Text(
          "Attendance Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
