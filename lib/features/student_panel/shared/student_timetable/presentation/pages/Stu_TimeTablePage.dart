import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../../../student_courses/presentation/controllers/StudentCoursesController.dart';
import '../../../student_courses/presentation/bindings/StudentCoursesBinding.dart';
import 'dart:math';

class Stu_TimeTablePage extends StatefulWidget {
  final String studentDept;
  const Stu_TimeTablePage({Key? key, required this.studentDept}) : super(key: key);

  @override
  State<Stu_TimeTablePage> createState() => _Stu_TimeTablePageState();
}

class _Stu_TimeTablePageState extends State<Stu_TimeTablePage> {
  late final StudentCoursesController coursesController;

  @override
  void initState() {
    super.initState();
    // Initialize the binding
    StudentCoursesBinding().dependencies();
    // Get the controller instance
    coursesController = Get.find<StudentCoursesController>();
    // Fetch courses for the student's department
    coursesController.fetchStudentCourses(widget.studentDept);
  }

  final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final List<String> timeSlots = [
    '8:30 - 10:00',
    '10:15 - 11:45',
    '12:00 - 1:30',
    '2:00 - 3:30',
    '3:45 - 5:15'
  ];

  // Generate a random timetable based on available courses
  Map<String, Map<String, String>> generateTimeTable(List<StudentCourse> courses) {
    final Map<String, Map<String, String>> timetable = {};
    final List<String> courseNames = courses.map((c) => c.courseName).toList();
    
    // Initialize timetable structure
    for (String day in weekDays) {
      timetable[day] = {};
      for (String slot in timeSlots) {
        // Randomly assign courses to slots
        if (courseNames.isNotEmpty) {
          final randomIndex = DateTime.now().millisecondsSinceEpoch % courseNames.length;
          timetable[day]![slot] = courseNames[randomIndex];
        }
      }
    }
    
    return timetable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
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
        if (coursesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (coursesController.coursesList.isEmpty) {
          return const Center(child: Text('No courses available'));
        }

        final timetable = generateTimeTable(coursesController.coursesList);

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Weekly Schedule',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
                child: Column(
                  children: weekDays.map((day) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Get.theme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...timeSlots.map((slot) {
                          final course = timetable[day]![slot];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course ?? 'No Class',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Room: ${_getRandomRoom()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildWeekendDay('Saturday'),
                        const SizedBox(width: 16),
                        _buildWeekendDay('Sunday'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWeekendDay(String day) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.weekend,
              color: Get.theme.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              day,
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'No Classes',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRandomRoom() {
    final rooms = ['Room 101', 'Room 102', 'Room 201', 'Room 202', 'Lab 1', 'Lab 2'];
    return rooms[DateTime.now().millisecondsSinceEpoch % rooms.length];
  }

  Widget _buildTimeTable() {
    // Get courses from controller
    final courses = coursesController.coursesList;
    
    // Create a list of time slots
    final timeSlots = [
      '8:30 - 9:50',
      '10:00 - 11:20',
      '11:30 - 12:50',
      '2:00 - 3:20',
      '3:30 - 4:50',
    ];

    // Create a list of days
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    // Create a map to store the timetable
    final Map<String, Map<String, String>> timetable = {};

    // Initialize timetable with empty slots
    for (var day in days) {
      timetable[day] = {};
      for (var slot in timeSlots) {
        timetable[day]![slot] = 'No Lecture';
      }
    }

    // Create a list of all possible course combinations
    final List<String> allCourseCombinations = [];
    if (courses.isNotEmpty) {
      for (var course in courses) {
        allCourseCombinations.add('${course.courseName}\n${course.courseCode}');
      }
    }
    // Add some empty slots to the combinations
    allCourseCombinations.addAll(List.filled(5, 'No Lecture'));

    // Randomly assign different courses to each day
    final random = Random();
    for (var day in days) {
      // Create a copy of course combinations for this day
      List<String> dayCourses = List.from(allCourseCombinations);
      // Shuffle the courses for this day
      dayCourses.shuffle(random);
      
      // Assign courses to slots for this day
      for (var i = 0; i < timeSlots.length; i++) {
        if (i < dayCourses.length) {
          timetable[day]![timeSlots[i]] = dayCourses[i];
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Get.theme.primaryColor),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dataRowColor: MaterialStateProperty.all(Colors.white),
          columns: [
            const DataColumn(label: Text('Time')),
            ...days.map((day) => DataColumn(label: Text(day))).toList(),
          ],
          rows: timeSlots.map((slot) {
            return DataRow(
              cells: [
                DataCell(Text(slot)),
                ...days.map((day) => DataCell(
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      timetable[day]![slot]!,
                      style: TextStyle(
                        color: timetable[day]![slot] == 'No Lecture' 
                          ? Colors.grey 
                          : Get.theme.primaryColor,
                        fontWeight: timetable[day]![slot] == 'No Lecture' 
                          ? FontWeight.normal 
                          : FontWeight.bold,
                      ),
                    ),
                  ),
                )).toList(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
