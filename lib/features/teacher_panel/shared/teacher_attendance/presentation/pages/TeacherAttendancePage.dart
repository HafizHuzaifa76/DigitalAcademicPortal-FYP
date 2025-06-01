import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/TeacherAttendanceController.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String teacherDept;

  const TeacherAttendancePage({super.key, required this.teacherDept});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  final TeacherAttendanceController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getTeacherCourses(widget.teacherDept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Selection'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor,
                const Color(0xFF1B7660),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coursesList.isEmpty) {
          return const Center(child: Text('No courses available'));
        }

        return ListView.builder(
          itemCount: controller.coursesList.length,
          itemBuilder: (context, index) {
            final course = controller.coursesList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(course.courseName),
                subtitle: Text('Section: ${course.courseSection}'),
                trailing: Text('Students: ${course.studentIds.length}'),
                onTap: () {
                  controller.updateSelectedCourse(course);
                  Get.to(() => TeacherAttendanceMarkingPage(course: course));
                },
              ),
            );
          },
        );
      }),
    );
  }
}

class TeacherAttendanceMarkingPage extends StatelessWidget {
  final TeacherCourse course;
  final TeacherAttendanceController controller = Get.find();

  TeacherAttendanceMarkingPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${course.courseName} Attendance'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor,
                const Color(0xFF1B7660),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: controller.selectedDate.value,
            selectedDayPredicate: (day) {
              return isSameDay(controller.selectedDate.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.updateSelectedDate(selectedDay);
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.attendanceList.isEmpty) {
                return const Center(child: Text('No attendance records'));
              }

              return ListView.builder(
                itemCount: controller.attendanceList.length,
                itemBuilder: (context, index) {
                  final attendance = controller.attendanceList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('Student ID: ${attendance.studentId}'),
                      trailing: Switch(
                        value: attendance.isPresent,
                        onChanged: (value) {
                          controller.updateStudentAttendance(
                              attendance.studentId, value);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.markAttendance();
        },
        label: const Text('Save Attendance'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
