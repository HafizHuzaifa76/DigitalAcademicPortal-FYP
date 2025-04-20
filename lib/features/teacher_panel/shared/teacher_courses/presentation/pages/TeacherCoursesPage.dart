import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherCourseController.dart';

class TeacherCoursesPage extends StatefulWidget {
  final String teacherDept;
  const TeacherCoursesPage({super.key, required this.teacherDept});

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
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.coursesList.isEmpty) {
          return const Center(child: Text('No courses assigned'));
        }
        
        return ListView.builder(
          itemCount: controller.coursesList.length,
          itemBuilder: (context, index) {
            final course = controller.coursesList[index];
            return ListTile(
              title: Text(course.courseName),
              subtitle: Text('${course.courseCode} - Section ${course.courseSection}'),
              trailing: Text(course.courseSemester),
            );
          },
        );
      }),
    );
  }
}