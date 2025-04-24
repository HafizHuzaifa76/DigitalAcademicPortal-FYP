
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
            ),
            child: Column(
              children: [
                SizedBox(
                    height: 90,
                    child: Image.asset('assets/images/DAP_logo_light.png')),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Digital',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Get.theme.primaryColorLight,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' Academic ',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Get.theme.primaryColorLight,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Portal',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Get.theme.primaryColorLight,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ListTile(
            leading: Image.asset('assets/images/attendance2.png', height: 30, width: 30),
            title: Text('Attendance', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_attendance');
            },
          ),
          const Divider(),

          // ListTile(
          //   leading: Image.asset('assets/images/students_icon.png', height: 30, width: 30),
          //   title: Text('Students', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
          //   onTap: () {
          //     Get.toNamed('/allStudents');
          //   },
          // ),
          // const Divider(),

          // ListTile(
          //   leading: Image.asset('assets/images/grades.png', height: 30, width: 30),
          //   title: Text('Grades', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
          //   onTap: () {
          //     Get.toNamed('/student_gradesScreen');
          //   },
          // ),
          // const Divider(),

          ListTile(
            leading: Image.asset('assets/images/course_icon.png', height: 30, width: 30),
            title: Text('Courses', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_allCourses');
            },
          ),
          const Divider(),

          ListTile(
            leading: Image.asset('assets/images/noticeboard_icon.png', height: 30, width: 30),
            title: Text('Notice Board', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_NoticeBoard');
            },
          ),
          const Divider(),
          ListTile(
            leading: Image.asset('assets/images/assign.png', height: 30, width: 30),
            title: Text('Assignments', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_assignments');
            },
          ),
          const Divider(),

          ListTile(
            leading: Image.asset('assets/images/calendar_icon.png', height: 30, width: 30),
            title: Text('Calendar', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_calendarPage');
            },
          ),
          const Divider(),

          // ListTile(
          //   leading: Image.asset('assets/images/chatbot_icon.png', height: 30, width: 30),
          //   title: Text('ChatBot', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
          //   onTap: () {
          //     Get.toNamed('/Stu_ChatBot');
          //   },
          // ),
          // const Divider(),

          ListTile(
            leading: Image.asset('assets/images/bugreport_icon.png', height: 30, width: 30),
            title: Text('Reports', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/teacher_reportsScreen');
            },
          ),
        ],
      ),
    );
  }
}
