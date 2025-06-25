import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/controllers/TeacherDashboardController.dart';
import 'package:digital_academic_portal/shared/domain/entities/Teacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/pages/LoginPage.dart';
import '../widgets/TeacherDrawer.dart';

class TeacherDashboardPage extends StatefulWidget {
  static Teacher? teacherProfile;
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => TeacherDashboardPageState();
}

class TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final TeacherDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const TeacherDrawer(),
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: screenSize.height * .25,
                width: screenSize.width,
                padding: const EdgeInsets.only(
                    top: 35, left: 15, right: 10, bottom: 3),
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: kIsWeb
                          ? screenSize.height * 0.25 * 0.3
                          : screenSize.height * 0.25 * 0.4,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 20,
                              right: 100,
                              left: 100,
                              child: Text(
                                kIsWeb
                                    ? 'Teacher Dashboard'
                                    : 'Teacher \nDashboard',
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle,
                                textAlign: TextAlign.center,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Wrap IconButton with Builder to get a proper context
                              Builder(
                                builder: (context) {
                                  return SizedBox(
                                    height: 20,
                                    child: IconButton(
                                        padding: const EdgeInsets.all(5),
                                        onPressed: () {
                                          Scaffold.of(context)
                                              .openDrawer(); // Open drawer on click
                                        },
                                        icon: const Icon(
                                          Icons.sort,
                                          color: Colors.white,
                                          size: 28,
                                        )),
                                  );
                                },
                              ),

                              IconButton(
                                icon: Image.asset(
                                  'assets/images/admin.png',
                                  height: 35,
                                  width: 35,
                                ),
                                onPressed: () => _showCustomMenu(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          color: const Color(0xFF128771),
                          borderOnForeground: true,
                          semanticContainer: true,
                          shadowColor: Colors.black,
                          child: SizedBox(
                            height: screenSize.height * 0.25 * 0.34,
                            width: screenSize.width * 0.30,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Department',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      textAlign: TextAlign.center,
                                    ),
                                    AutoSizeText(
                                      controller.teacher.value?.teacherDept ??
                                          '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: const Color(0xFF128771),
                          child: SizedBox(
                            height: screenSize.height * 0.25 * 0.34,
                            width: screenSize.width * 0.28,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Courses',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu'),
                                      textAlign: TextAlign.center,
                                    ),
                                    AutoSizeText(
                                      '0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: const Color(0xFF128771),
                          surfaceTintColor: Colors.black,
                          shadowColor: Theme.of(context).primaryColorLight,
                          child: SizedBox(
                            height: screenSize.height * 0.25 * 0.34,
                            width: screenSize.width * 0.28,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Faculty Type',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu'),
                                      textAlign: TextAlign.center,
                                    ),
                                    AutoSizeText(
                                      controller.teacher.value?.teacherType ??
                                          '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu',
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: screenSize.height * .75,
                width: screenSize.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 10),

                    Column(
                      children: [
                        SizedBox(
                            height: 120,
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
                    const SizedBox(height: 10),

                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherAttendancePage', arguments: {
                                'teacherDept':
                                    controller.teacher.value?.teacherDept ?? ''
                              });
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/attendanceB.png',
                                height: 60,
                                width: 60,
                              ),
                              AutoSizeText(
                                'Attendance',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherTimetablePage', arguments: {
                                'teacherCNIC':
                                    controller.teacher.value?.teacherCNIC ?? ''
                              });
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/timetablebg.png',
                                  height: 60, width: 75),
                              AutoSizeText(
                                'Time Table',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherAssignments');
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/gradesbg.png',
                                  height: 60, width: 60),
                              AutoSizeText(
                                'Assignments',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherCoursesPage', arguments: {
                                'teacherDept':
                                    controller.teacher.value?.teacherDept ?? ''
                              });
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/course_icon.png',
                                  height: 55, width: 60),
                              const SizedBox(height: 3),
                              AutoSizeText(
                                ' Courses ',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherAnnouncement');
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/noticeboard_icon.png',
                                  height: 55, width: 60),
                              const SizedBox(height: 5),
                              AutoSizeText(
                                'Announcement',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          // onPressed: () => Get.to(const TableEventsExample()),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherCalendarPage');
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/calendar_icon.png',
                                  height: 50, width: 60),
                              const SizedBox(height: 7),
                              AutoSizeText(
                                ' Calendar ',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(
                                  Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5))),
                          // onPressed: () => Get.to(const TableEventsExample()),
                          onPressed: () {
                            if (controller.teacher.value != null) {
                              Get.toNamed('/teacherGradePage', arguments: {
                                'teacherDept':
                                    controller.teacher.value?.teacherDept ?? ''
                              });
                            } else {
                              Utils().showErrorSnackBar('Error',
                                  'Teacher data not loaded. Please wait or refresh.');
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/grades.png',
                                  height: 50, width: 60),
                              const SizedBox(height: 7),
                              AutoSizeText(
                                'Assign Grades',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    //       child: ElevatedButton(
                    //         style: ButtonStyle(
                    //             backgroundColor: WidgetStatePropertyAll(
                    //                 Theme.of(context).primaryColor),
                    //             fixedSize: WidgetStatePropertyAll(
                    //                 Size(screenSize.width * .3, 100)),
                    //             shape: WidgetStatePropertyAll(
                    //                 RoundedRectangleBorder(
                    //                     borderRadius:
                    //                     BorderRadius.circular(10))),
                    //             padding: const WidgetStatePropertyAll(
                    //                 EdgeInsets.symmetric(
                    //                     horizontal: 12, vertical: 5))),
                    //         onPressed: () => Get.toNamed('/Stu_ChatBot'),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Image.asset('assets/images/chatbot_icon.png',
                    //                 height: 60, width: 60),
                    //             const AutoSizeText(
                    //               ' ChatBot ',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontFamily: 'Ubuntu',
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.bold),
                    //               maxLines: 1,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    //       child: ElevatedButton(
                    //         style: ButtonStyle(
                    //             backgroundColor: WidgetStatePropertyAll(
                    //                 Theme.of(context).primaryColor),
                    //             fixedSize: WidgetStatePropertyAll(
                    //                 Size(screenSize.width * .3, 100)),
                    //             shape: WidgetStatePropertyAll(
                    //                 RoundedRectangleBorder(
                    //                     borderRadius:
                    //                     BorderRadius.circular(10))),
                    //             padding: const WidgetStatePropertyAll(
                    //                 EdgeInsets.symmetric(
                    //                     horizontal: 12, vertical: 5))),
                    //         onPressed: () => Get.toNamed('/student_diary'),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Image.asset('assets/images/diary.png',
                    //                 height: 60, width: 60),
                    //             const AutoSizeText(
                    //               ' Students Diary ',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontFamily: 'Ubuntu',
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.bold),
                    //               maxLines: 1,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomMenu(BuildContext context) {
    final RenderBox appBarBox = context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        appBarBox.size.width, // Adjust the X position to align with the icon
        70, // Adjust the Y position to the bottom of the AppBar
        appBarBox.size.width, // This would be a maximum width after X position
        appBarBox.size.height +
            200, // This would be a maximum height after Y position
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            children: [
              ListTile(
                title: Text(
                    'Hi, ${controller.teacher.value?.teacherName ?? 'Loading...'}!'),
                subtitle: Text(
                    controller.teacher.value?.teacherEmail ?? 'Loading...'),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: Text('Sign out',
                    style: TextStyle(color: Colors.red.shade700)),
                onTap: () {
                  Get.back(); // Close the drawer
                  Get.off(() => const LoginPage());
                },
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
