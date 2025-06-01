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

  Widget _buildBarChart(double value) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  toY: value, color: Get.theme.primaryColor, width: 20),
            ]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
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

        final attendancePercentage = controller.calculateAttendancePercentage() / 100;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<StudentCourse>(
                  isExpanded: true,
                  value: controller.selectedCourse.value,
                  items: controller.studentCourses.map((course) {
                    return DropdownMenuItem<StudentCourse>(
                      value: course,
                      child: Text(course.courseName),
                    );
                  }).toList(),
                  onChanged: (course) {
                    if (course != null) {
                      controller.updateSelectedCourse(course);
                    }
                  },
                  underline: Container(),
                ),
              ),
            ),
            // Circular Percent Indicator
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 13,
              animation: true,
              percent: attendancePercentage,
              center: Text(
                "${(attendancePercentage * 100).toStringAsFixed(1)}%",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              footer: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  "${controller.selectedCourse.value?.courseName ?? ''} Attendance",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.indigo,
              backgroundColor: Colors.indigo.shade100,
            ),
            const SizedBox(height: 32),
            // Bar Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildBarChart(attendancePercentage),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: controller.attendanceList.isEmpty
                  ? const Center(child: Text('No attendance records found'))
                  : ListView.builder(
                      itemCount: controller.attendanceList.length,
                      itemBuilder: (context, index) {
                        final attendance = controller.attendanceList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: Icon(
                              attendance.isPresent
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: attendance.isPresent
                                  ? Colors.green
                                  : Colors.red,
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
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}