import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'CourseGradesPage.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../controllers/TeacherGradeController.dart';

class TeachersGradePage extends StatefulWidget {
  final String teacherDept;

  const TeachersGradePage({super.key, required this.teacherDept});

  @override
  State<TeachersGradePage> createState() => _TeachersGradePageState();
}

class _TeachersGradePageState extends State<TeachersGradePage> {
  final TeacherGradeController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getTeacherCourses(widget.teacherDept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                  return _buildCourseCard(context, course);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCourseCard(BuildContext context, TeacherCourse course) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          controller.updateSelectedCourse(course);
          Get.to(() => CourseGradesPage(
                courseId: course.courseName,
                courseCode: course.courseCode,
                sectionClass: course.courseSection,
              ));
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
                          course.courseSection,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    if (courseCode.toLowerCase().contains('mobile')) {
      return Icons.phone_android;
    } else if (courseCode.toLowerCase().contains('web')) {
      return Icons.web;
    } else if (courseCode.toLowerCase().contains('database')) {
      return Icons.storage;
    } else if (courseCode.toLowerCase().contains('programming')) {
      return Icons.code;
    } else {
      return Icons.book;
    }
  }
}
