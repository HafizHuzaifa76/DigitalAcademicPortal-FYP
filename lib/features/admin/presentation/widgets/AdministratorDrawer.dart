
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdministratorDrawer extends StatelessWidget {
  const AdministratorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                    height: 90,
                    child: Image.asset('assets/images/DAP logo.png')),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Digital',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Theme.of(context).primaryColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      ' Academic ',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Portal',
                      style: TextStyle(
                          fontFamily: 'Belanosima',
                          color: Theme.of(context).primaryColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset('assets/images/department_icon.png', height: 30, width: 30),
            title: Text('Departments', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/departments');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/students_icon.png', height: 30, width: 30),
            title: Text('Students', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/allStudents');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/th1.png', height: 30, width: 30),
            title: Text('Teachers', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/allTeachers');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/course_icon.png', height: 30, width: 30),
            title: Text('Courses', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/allCourses');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/noticeboard_icon.png', height: 30, width: 30),
            title: Text('Notice Board', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/calendar_icon.png', height: 30, width: 30),
            title: Text('Calendar', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/chatbot_icon.png', height: 30, width: 30),
            title: Text('ChatBot', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/');
            },
          ),
          ListTile(
            leading: Image.asset('assets/images/bugreport_icon.png', height: 30, width: 30),
            title: Text('Reports', style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              Get.toNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
