import 'package:flutter/material.dart';

class Stu_ChatBot extends StatelessWidget {
  const Stu_ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot"),
      ),
      body: const Center(
        child: Text(
          "Chat Bot Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
