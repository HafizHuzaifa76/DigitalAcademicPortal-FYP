import 'package:flutter/material.dart';
import '../stu_controllers/day_task_tile.dart';
import '../theme/app_theme.dart'; // 💚 Import your custom theme here

class Stu_Diary extends StatelessWidget {
  const Stu_Diary({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme, // 🟢 Apply your theme only to this screen
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Diary"),
        ),
        body: ListView.builder(
          itemCount: 30, // Show last 30 days
          reverse: true,
          itemBuilder: (context, index) {
            final day = DateTime.now().subtract(Duration(days: index));
            return DayTaskTile(date: day);
          },
        ),
      ),
    );
  }
}
