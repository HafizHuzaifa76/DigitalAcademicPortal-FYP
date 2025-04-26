import 'package:flutter/material.dart';

class TeacherAnnouncementPage extends StatelessWidget {
  const TeacherAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcement"),
      ),
      body: const Center(
        child: Text(
          "Teacher Announcement Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
