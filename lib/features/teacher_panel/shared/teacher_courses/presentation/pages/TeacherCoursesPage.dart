import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherCourseController.dart';

class TeacherCoursesPage extends StatefulWidget {
  final String teacherDept;
  final int? detailPage;
  const TeacherCoursesPage({super.key, required this.teacherDept, this.detailPage});

  @override
  State<TeacherCoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<TeacherCoursesPage> {
  final TeacherCourseController controller = Get.find();

  @override
  void initState() {
    controller.getTeacherCourses(widget.teacherDept);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.detailPage == null ? 'My Courses' : 'Select Course',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coursesList.isEmpty) {
          return const Center(child: Text('No courses assigned'));
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
                  return _buildCourseCard(course);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCourseCard(course) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/teacherCourseDetailPage', arguments: {'course': course, 'detailPage': widget.detailPage});
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
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
                        Icons.calendar_today,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.courseSemester,
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
                    child: Text(
                      course.courseCode,
                      style: const TextStyle(
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
