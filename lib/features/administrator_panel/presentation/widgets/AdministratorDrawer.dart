import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdministratorDrawer extends StatelessWidget {
  const AdministratorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // You can replace these with actual admin info if available
    const String adminName = 'Administrator';
    final String adminEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Modern Header with gradient and logo
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
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/DAP logo.png'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminName,
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
                        adminEmail,
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
            icon: 'assets/images/department_icon.png',
            title: 'Departments',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/departments');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/students_icon.png',
            title: 'Students',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/allStudents');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/th1.png',
            title: 'Teachers',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/allTeachers');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/admin.png',
            title: 'Sub Admins',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/subAdminsPage');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/course_icon.png',
            title: 'Courses',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/allCourses');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/noticeboard_icon.png',
            title: 'Notice Board',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/mainNoticeBoard');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/calendar_icon.png',
            title: 'Calendar',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/calendarPage');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/chatbot_icon.png',
            title: 'ChatBot',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/adminChatBotPage');
            },
          ),
          _modernListTile(
            context,
            icon: 'assets/images/bugreport_icon.png',
            title: 'Reports',
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/adminReportsPage');
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
