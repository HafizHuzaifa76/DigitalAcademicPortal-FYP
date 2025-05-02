import 'package:flutter/material.dart';

class TeacherQueryPage extends StatelessWidget {
  const TeacherQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queries Section"),
      ),
      body: const Center(
        child: Text(
          "Queries",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
