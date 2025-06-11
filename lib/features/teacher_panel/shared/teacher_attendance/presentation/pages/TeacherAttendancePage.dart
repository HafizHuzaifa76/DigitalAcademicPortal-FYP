import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherAttendanceController.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import 'package:intl/intl.dart';

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

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2.3,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.coursesList.length,
                itemBuilder: (context, index) {
                  final course = controller.coursesList[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        controller.updateSelectedCourse(course);
                        Get.to(() => TeacherAttendanceMarkingPage(course: course));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Section: ${course.courseSection}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  _getIconForCourse(course.courseName),
                                  color: Colors.white.withOpacity(0.7),
                                  size: 28,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${course.studentIds.length} students",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Take Attendance',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  IconData _getIconForCourse(String courseName) {
    if (courseName.toLowerCase().contains('mobile')) {
      return Icons.phone_android;
    } else if (courseName.toLowerCase().contains('web')) {
      return Icons.web;
    } else if (courseName.toLowerCase().contains('database')) {
      return Icons.storage;
    } else if (courseName.toLowerCase().contains('programming')) {
      return Icons.code;
    } else {
      return Icons.book;
    }
  }
}

class TeacherAttendanceMarkingPage extends StatelessWidget {
  final TeacherCourse course;
  final TeacherAttendanceController controller = Get.find();

  TeacherAttendanceMarkingPage({super.key, required this.course});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _getLastValidDate(controller.selectedDate.value),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      selectableDayPredicate: (DateTime date) {
        // Allow only Tuesdays (2) and Thursdays (4)
        return date.weekday == DateTime.tuesday ||
            date.weekday == DateTime.thursday;
      },
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.updateSelectedDate(picked);
    }
  }

  DateTime _getLastValidDate(DateTime date) {
    // If current date is not Tuesday or Thursday, find the last valid date
    while (
        date.weekday != DateTime.tuesday && date.weekday != DateTime.thursday) {
      date = date.subtract(const Duration(days: 1));
    }
    return date;
  }

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
          // Date Picker Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Obx(() => OutlinedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          'Date: ${DateFormat('dd-MMM-yyyy').format(_getLastValidDate(controller.selectedDate.value))}',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                        onPressed: () => controller.toggleAllAttendance(),
                        icon: Icon(
                            controller.isAllMarked.value
                                ? Icons.cancel_outlined
                                : Icons.check_circle_outline,
                            color: Colors.white),
                        label: AutoSizeText(
                          controller.isAllMarked.value
                              ? 'Unmark All'
                              : 'Mark All',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          maxLines: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          // Statistics Component
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              final presentCount = controller.filteredAttendanceList
                  .where((student) => student.isPresent)
                  .length;
              final totalCount = controller.filteredAttendanceList.length;
              final absentCount = totalCount - presentCount;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    count: presentCount,
                    label: 'Present',
                    icon: Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildStatItem(
                    count: absentCount,
                    label: 'Absent',
                    icon: Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ],
              );
            }),
          ),
          // Attendance List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredAttendanceList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No attendance records for selected date'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.loadAttendance(),
                        child: const Text('Create New Attendance'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Text(
                          controller.isExistingAttendance.value
                              ? 'Editing existing attendance for ${DateFormat('dd-MMM-yyyy').format(controller.selectedDate.value)}'
                              : 'Creating new attendance for ${DateFormat('dd-MMM-yyyy').format(controller.selectedDate.value)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filteredAttendanceList.length,
                      itemBuilder: (context, index) {
                        final attendance =
                            controller.filteredAttendanceList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                    ),
                  ),
                ],
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

  Widget _buildStatItem({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
