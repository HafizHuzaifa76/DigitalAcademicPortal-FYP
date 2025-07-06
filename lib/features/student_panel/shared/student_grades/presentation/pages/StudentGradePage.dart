import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'CurrentSemesterGradePage.dart';
import 'PreviousCoursesGradePage.dart';
import '../manager/StudentGradeController.dart';

class StudentGradePage extends StatefulWidget {
  const StudentGradePage({Key? key}) : super(key: key);

  @override
  State<StudentGradePage> createState() => _StudentGradePageState();
}

class _StudentGradePageState extends State<StudentGradePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    CurrentSemesterGradePage(),
    PreviousCoursesGradePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, const Color(0xFF1B7660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Grades',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Ubuntu'),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: 'Current Semester',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_outlined),
              label: 'Previous Courses',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
