import 'package:flutter/material.dart';
import 'CourseAssignmentsPage.dart';
import '../../../teacher_grades/domain/entities/Course.dart';

class TeachersGradeScreen extends StatelessWidget {
  TeachersGradeScreen({super.key});

  // Sample course data
  final List<Course> courses = [
    Course(
      id: '1',
      courseCode: 'ASE',
      sectionClass: 'A4',
      teacherName: 'Sabin Amjad',
      teacherId: 'T001',
      studentCount: 30,
      semester: 'Fall 2024',
    ),
    Course(
      id: '2',
      courseCode: 'SQA',
      sectionClass: 'A1',
      teacherName: 'Sabin Amjad',
      teacherId: 'T001',
      studentCount: 35,
      semester: 'Fall 2024',
    ),
    Course(
      id: '3',
      courseCode: 'TIERS Limited Summer Internship',
      sectionClass: 'Mobile App Development',
      teacherName: 'Instructor Name',
      teacherId: 'T003',
      studentCount: 22,
      semester: 'Summer 2024',
    ),
    Course(
      id: '4',
      courseCode: 'Mobile App Development',
      sectionClass: 'A1 & A3',
      teacherName: 'Hassaan Ahmed',
      teacherId: 'T002',
      studentCount: 40,
      semester: 'Fall 2024',
    ),
    Course(
      id: '5',
      courseCode: 'Mobile development',
      sectionClass: 'Mobile App Dev',
      teacherName: 'Instructor Name',
      teacherId: 'T003',
      studentCount: 25,
      semester: 'Fall 2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'My Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
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
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return _buildCourseCard(
                  context,
                  course,
                  gradients[index % gradients.length],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    Course course,
    LinearGradient gradient,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseAssignmentsPage(
                courseId: course.id,
                courseCode: course.courseCode,
                sectionClass: course.sectionClass,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(gradient: gradient),
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
                          course.courseCode,
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
                          course.sectionClass,
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
                    _getIconForCourse(course.courseCode),
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
                        "${course.studentCount} students",
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
                      'View',
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
  }

  IconData _getIconForCourse(String courseCode) {
    if (courseCode.contains('Mobile')) {
      return Icons.phone_android;
    } else if (courseCode.contains('ASE')) {
      return Icons.architecture;
    } else if (courseCode.contains('SQA')) {
      return Icons.verified;
    } else if (courseCode.contains('TIERS')) {
      return Icons.business;
    } else {
      return Icons.code;
    }
  }

  // Gradient presets
  final List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xFF303F9F), Color(0xFF5C6BC0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF512DA8), Color(0xFF7E57C2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF0097A7), Color(0xFF26C6DA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF00796B), Color(0xFF26A69A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF455A64), Color(0xFF78909C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}