import '../theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../manager/day_task_tile.dart';

class Stu_Diary extends StatelessWidget {
  const Stu_Diary({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
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
