import 'package:flutter/material.dart';

class Tch_MainNoticeBoardPage extends StatelessWidget {
  const Tch_MainNoticeBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Noticeboard"),
      ),
      body: const Center(
        child: Text(
          "Teacher Noticeboard Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
