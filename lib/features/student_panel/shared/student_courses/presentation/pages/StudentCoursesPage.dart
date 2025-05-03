import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/StudentCoursesController.dart';

class StudentCoursesPage extends GetView<StudentCoursesController> {
  const StudentCoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coursesList.isEmpty) {
          return const Center(child: Text('No courses found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.coursesList.length,
          itemBuilder: (context, index) {
            final course = controller.coursesList[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${course.courseName} (${course.courseCode})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Teacher: ${course.teacherName}'),
                    Text('Section: ${course.courseSection}'),
                    Text('Credit Hours: ${course.courseCreditHours}'),
                    Text('Type: ${course.courseType}'),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}