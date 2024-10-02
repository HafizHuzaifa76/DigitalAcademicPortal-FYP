import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/CourseController.dart';
import 'CourseDetailPage.dart';

class SemesterCoursePage extends StatefulWidget {
  final String deptName;
  final String semester;
  const SemesterCoursePage({super.key, required this.deptName, required this.semester});

  @override
  State<SemesterCoursePage> createState() => _SemesterCoursePageState();
}

class _SemesterCoursePageState extends State<SemesterCoursePage> {
  final CourseController controller = Get.find();

  @override
  void initState() {
    controller.showSemesterCourses(widget.deptName, widget.semester);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.semester} Courses'),
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: ()=> controller.addCourse(widget.deptName),
          // )
        ],
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
            if (controller.courseList.isEmpty) {
              return const Center(child: Text("No Courses available"));
            } else {
              return ListView.builder(
                itemCount: controller.courseList.length,
                itemBuilder: (context, index) {
                  final course = controller.courseList[index];
                  return ListTile(
                    title: Text(course.courseName),
                    subtitle: const Text(''),
                    onTap: () {
                      Get.to(()=> CourseDetailPage(deptName: widget.deptName, course: course));
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
