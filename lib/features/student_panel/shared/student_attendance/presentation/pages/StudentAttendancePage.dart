import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../manager/StudentAttendanceController.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final StudentAttendanceController controller = Get.find();

  Widget _buildPieChart(double presentPercentage) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Attendance Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: presentPercentage,
                    title: '${(presentPercentage * 100).toStringAsFixed(1)}%',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 1 - presentPercentage,
                    title:
                        '${((1 - presentPercentage) * 100).toStringAsFixed(1)}%',
                    color: Colors.red,
                    radius: (1 - presentPercentage) * 100 == 100 ? 60 : 80,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                startDegreeOffset: -90,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStats(int present, int absent) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Attendance Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildStatItem(
                  'Present',
                  present.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              Container(
                height: 40,
                width: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Expanded(
                child: _buildStatItem(
                  'Absent',
                  absent.toString(),
                  Colors.red,
                  Icons.cancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
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
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 120,
              height: 120,
              fit: BoxFit.scaleDown,
            ),
          );
        }

        if (controller.studentCourses.isEmpty) {
          return const Center(
            child: Text('No courses available'),
          );
        }

        final attendancePercentage =
            controller.calculateAttendancePercentage() / 100;
        final presentCount =
            controller.attendanceList.where((a) => a.isPresent).length;
        final absentCount =
            controller.attendanceList.where((a) => !a.isPresent).length;

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: DropdownButton<StudentCourse>(
                  isExpanded: true,
                  value: controller.selectedCourse.value,
                  items: controller.studentCourses.map((course) {
                    return DropdownMenuItem<StudentCourse>(
                      value: course,
                      child: Text(
                        course.courseName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (course) {
                    if (course != null) {
                      controller.updateSelectedCourse(course);
                    }
                  },
                  underline: Container(),
                  icon: Icon(Icons.arrow_drop_down,
                      color: Get.theme.primaryColor),
                ),
              ),
              // Attendance Stats
              _buildAttendanceStats(presentCount, absentCount),
              // Pie Chart
              _buildPieChart(attendancePercentage),
              // Attendance History
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.attendanceList.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No attendance records found'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: controller.attendanceList.length,
                        itemBuilder: (context, index) {
                          final attendance = controller.attendanceList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: attendance.isPresent
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  attendance.isPresent
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: attendance.isPresent
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              title: Text(
                                attendance.date.toString().split(' ')[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: attendance.remarks != null
                                  ? Text(attendance.remarks!)
                                  : null,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: attendance.isPresent
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  attendance.isPresent ? 'Present' : 'Absent',
                                  style: TextStyle(
                                    color: attendance.isPresent
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Bottom padding
            ],
          ),
        );
      }),
    );
  }
}
