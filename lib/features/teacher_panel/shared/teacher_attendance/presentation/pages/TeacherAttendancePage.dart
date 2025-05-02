import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_attendance/presentation/controllers/TeacherAttendanceController.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/entities/TeacherCourse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String teacherDept;
  const TeacherAttendancePage({super.key, required this.teacherDept});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage>
    with SingleTickerProviderStateMixin {
  final TeacherAttendanceController controller = Get.find();
  late TabController _tabController;

  final Map<String, double> attendanceData = {
    'Daily': 0.92,
    'Weekly': 0.87,
    'Monthly': 0.75,
  };

  @override
  void initState() {
    super.initState();
    controller.getTeacherCourses(widget.teacherDept);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildBarChart(double value) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  toY: value * 100, color: Colors.blueAccent, width: 20),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Attendance'), backgroundColor: Colors.green),
      body: Column(
        children: [
          Container(
            color: Get.theme.primaryColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.indigo,
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
            ),
          ),

          // Add Course Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButton<TeacherCourse>(
                    value: controller.selectedCourse.value,
                    isExpanded: true,
                    hint: const Text('Select Course'),
                    underline: const SizedBox(),
                    items: controller.coursesList
                        .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(
                                  '${course.courseSemester} - ${course.courseSection} - ${course.courseName}'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedCourse.value = value;
                      }
                    },
                  )),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ['Daily', 'Weekly', 'Monthly'].map((key) {
                double value = attendanceData[key]!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 13,
                        animation: true,
                        percent: value,
                        center: Text(
                          "${(value * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "$key Attendance",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.indigo,
                        backgroundColor: Colors.indigo.shade100,
                      ),
                      const SizedBox(height: 32),
                      _buildBarChart(value),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Attendance Summary",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                  "Classes Attended: ${(value * 30).round()}/30"),
                              Text("Absences: ${(30 - value * 30).round()}"),
                              Text(
                                  "Overall Percentage: ${(value * 100).toStringAsFixed(1)}%"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
