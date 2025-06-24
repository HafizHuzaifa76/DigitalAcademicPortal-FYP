import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'CurrentSemesterGradePage.dart';
import 'PreviousCoursesGradePage.dart';
import '../manager/StudentGradeController.dart';

class StudentGradePage extends StatelessWidget {
  const StudentGradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        appBar: AppBar(
          title: const Text('Grades'),
          centerTitle: true,
          elevation: 4,
          backgroundColor: const Color(0xFF00796B),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current Semester'),
              Tab(text: 'Previous Courses'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurrentSemesterGradePage(),
            PreviousCoursesGradePage(),
          ],
        ),
      ),
    );
  }
}
