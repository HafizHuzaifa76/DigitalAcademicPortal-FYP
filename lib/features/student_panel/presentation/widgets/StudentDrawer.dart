import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/StudentInfoPage.dart';
import '../pages/StudentDashboardPage.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final student = StudentDashboardPage.studentProfile;
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Modern Header with gradient and profile icon
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  const Color(0xFF1B7660),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding:
                const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24),
            child: Row(
              children: [
                // Profile avatar
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => StudentInfoPage());
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      student?.studentName[0].toUpperCase() ?? '?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student?.studentName ?? 'Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ubuntu',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student?.studentEmail ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Ubuntu',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _modernListTile(
            context,
            icon: 'assets/images/attendance2.png',
            title: 'Attendance',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/student_attendance');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/assign.png',
            title: 'Pending Assignments',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/pendingAssignment');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/course_icon.png',
            title: 'Courses',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentCoursesPage',
                  arguments: {'studentDept': student?.studentDepartment ?? ''});
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/gradesbg.png',
            title: 'Course Material',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentCoursesPage', arguments: {
                'studentDept': student?.studentDepartment ?? '',
                'detailPage': 0
              });
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/ask.png',
            title: 'Ask Query',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentCoursesPage', arguments: {
                'studentDept': student?.studentDepartment ?? '',
                'detailPage': 1
              });
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/noticeboard_icon.png',
            title: 'Announcements',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentCoursesPage', arguments: {
                'studentDept': student?.studentDepartment ?? '',
                'detailPage': 2
              });
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/diary.png',
            title: 'Students Diary',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentDiary', arguments: {
                'deptName': student?.studentDepartment ?? '',
                'studentRollNo': student?.studentRollNo ?? '',
              });
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/calendar_icon.png',
            title: 'Calendar',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/calendarViewPage');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/chatbot_icon.png',
            title: 'ChatBot',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/studentChatbotPage');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/bugreport_icon.png',
            title: 'Reports',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/Stu_report');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

Widget _modernListTile(BuildContext context,
    {required String icon,
    required String title,
    required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Image.asset(icon, height: 30, width: 30),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Theme.of(context).primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.07),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.12),
      ),
    ),
  );
}
