import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../manager/StudentGradeController.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class CurrentSemesterGradePage extends GetView<StudentGradeController> {
  const CurrentSemesterGradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

      return Container(
        color: const Color(0xFFF8F9FA),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Select Course',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                  fontSize: 16,
                )),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<StudentCourse>(
                    value: controller.selectedCourse.value,
                    isExpanded: true,
                    items: controller.studentCourses
                        .map((course) => DropdownMenuItem(
                            value: course, child: Text(course.courseName)))
                        .toList(),
                    onChanged: (val) {
                      controller.updateSelectedCourse(val!);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...controller.categories
                .map((category) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(category.toUpperCase(), theme),
                        ...controller.getGradesByCategory(category).map(
                            (grade) => _buildGradeRow(grade.title,
                                grade.totalMarks, grade.obtainedMarks, theme)),
                      ],
                    ))
                .toList(),
          ],
        ),
      );
    });
  }

  Widget _buildGradeRow(
      String title, int total, double obtained, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, const Color(0xFF1B7660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: $total',
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu',
                        fontSize: 15)),
                Text('Obtained: $obtained',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Ubuntu',
              color: theme.primaryColor)),
    );
  }
}
