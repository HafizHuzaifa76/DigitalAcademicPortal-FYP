import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../manager/StudentGradeController.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class CurrentSemesterGradePage extends GetView<StudentGradeController> {
  const CurrentSemesterGradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('SELECT COUSE',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<StudentCourse>(
            value: controller.selectedCourse.value,
            items: controller.studentCourses
                .map((course) => DropdownMenuItem(
                    value: course, child: Text(course.courseName)))
                .toList(),
            onChanged: (val) {
              print('val');
              print(val);
              controller.updateSelectedCourse(val!);
            },
          ),
          const SizedBox(height: 20),
          ...controller.categories
              .map((category) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(category.toUpperCase()),
                      ...controller.getGradesByCategory(category).map((grade) =>
                          _buildGradeRow(
                              grade.title, grade.totalMarks, grade.obtainedMarks)),
                    ],
                  ))
              .toList(),
        ],
      );
    });
  }

  Widget _buildGradeRow(String title, int total, double obtained) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Total: ${total.toString()}'),
          Text('Obtained: ${obtained.toString()}'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
