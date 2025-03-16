import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/CourseController.dart';


class AllCoursesPage extends StatefulWidget {

  const AllCoursesPage({super.key});

  @override
  State<AllCoursesPage> createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  final CourseController controller = Get.find();

  @override
  void initState() {
    // controller.showAllCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 100,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          }
          else {
            if (controller.semesterCourseList.isEmpty) {
              return const Center(child: Text("No Courses available"));
            } else {
              return ListView.builder(
                itemCount: controller.semesterCourseList.length,
                itemBuilder: (context, index) {
                  final course = controller.semesterCourseList[index];
                  return ListTile(
                    title: Text(course.courseName),
                    subtitle: Text(
                        'Code: ${course.courseCode}, Dept: ${course.courseDept}'),
                    onTap: () {
                      // Handle tap, e.g., navigate to Courses details or edit
                    },
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}
