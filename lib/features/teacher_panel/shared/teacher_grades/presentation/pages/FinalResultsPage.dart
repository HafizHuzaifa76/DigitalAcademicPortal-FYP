import 'dart:math';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_grades/presentation/controllers/TeacherGradeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';

class FinalResultsPage extends StatelessWidget {
  final Map<String, double> studentPercentages;
  final Map<String, double> studentTotals;
  final Map<String, double> studentMaxMarks;
  final String courseCode;
  final String sectionClass;
  final Map<String, double> weightages;
  final Map<String, Map<String, double>> studentGradeMarks;

  const FinalResultsPage({
    Key? key,
    required this.studentPercentages,
    required this.studentTotals,
    required this.studentMaxMarks,
    required this.courseCode,
    required this.sectionClass,
    required this.weightages,
    required this.studentGradeMarks,
  }) : super(key: key);

  double _calculateMean() {
    if (studentPercentages.isEmpty) return 0;
    final sum =
        studentPercentages.values.fold(0.0, (sum, value) => sum + value);
    return sum / studentPercentages.length;
  }

  double _calculateStandardDeviation(double mean) {
    if (studentPercentages.isEmpty) return 0;
    final squaredDifferences =
        studentPercentages.values.map((value) => pow(value - mean, 2));
    final variance = squaredDifferences.fold(0.0, (sum, value) => sum + value) /
        studentPercentages.length;
    return sqrt(variance);
  }

  String _getLetterGrade(
      double percentage, double sessionalPercentage, double finalPercentage) {
    if (sessionalPercentage < 50 || finalPercentage < 50) return 'F';
    final mean = _calculateMean();
    final stdDev = _calculateStandardDeviation(mean);
    if (percentage >= mean + 1.5 * stdDev) return 'A+';
    if (percentage >= mean + 1.0 * stdDev) return 'A';
    if (percentage >= mean + 0.5 * stdDev) return 'B+';
    if (percentage >= mean) return 'B';
    if (percentage >= mean - 0.5 * stdDev) return 'C+';
    if (percentage >= mean - 1.0 * stdDev) return 'C';
    if (percentage >= mean - 1.5 * stdDev) return 'D+';
    if (percentage >= mean - 2.0 * stdDev) return 'D';
    return 'F';
  }

  String _getFailureReason(double sessionalPercentage, double finalPercentage) {
    if (sessionalPercentage < 50 && finalPercentage < 50) {
      return 'Failed: Marks below 50%';
    } else if (sessionalPercentage < 50) {
      return 'Failed: Sessional marks below 50%';
    } else if (finalPercentage < 50) {
      return 'Failed: Final marks below 50%';
    }
    return '';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D+':
      case 'D':
        return Colors.orange.shade700;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _getGpaValue(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherGradeController>();
    final mean = _calculateMean();
    final stdDev = _calculateStandardDeviation(mean);
    final selectedCourse = controller.selectedCourse.value;
    final courseName = selectedCourse?.courseName ?? sectionClass;
    final courseCodeVal = selectedCourse?.courseCode ?? courseCode;
    final creditHour = selectedCourse?.courseCreditHours ?? 0;
    final semester = selectedCourse?.courseSemester ?? '';

    // Build the list of PreviousCourseGradeModel for all students
    final List<PreviousCourseGradeModel> previousGrades =
        studentPercentages.keys.map((studentId) {
      final percentage = studentPercentages[studentId]!;
      double sessionalMarks = 0;
      double finalMarks = 0;
      double sessionalMax = 0;
      double finalMax = 0;
      for (var entry in studentGradeMarks[studentId]!.entries) {
        final gradeTitle = entry.key;
        final marks = entry.value;
        final weightage = weightages[gradeTitle] ?? 0;
        if (gradeTitle.contains('Final')) {
          finalMarks += marks;
          finalMax += weightage;
        } else {
          sessionalMarks += marks;
          sessionalMax += weightage;
        }
      }
      final sessionalPercentage = sessionalMax > 0
          ? ((sessionalMarks / sessionalMax) * 100).toDouble()
          : 0.0;
      final finalPercentage =
          finalMax > 0 ? ((finalMarks / finalMax) * 100).toDouble() : 0.0;
      final letterGrade =
          _getLetterGrade(percentage, sessionalPercentage, finalPercentage);
      final isFailed = sessionalPercentage < 50 || finalPercentage < 50;
      final failureReason =
          _getFailureReason(sessionalPercentage, finalPercentage);
      final gpaValue = _getGpaValue(letterGrade);
      final calculatedGpa = gpaValue * creditHour;
      return PreviousCourseGradeModel(
        courseCode: courseCodeVal,
        course: courseName,
        studentId: studentId,
        sessionalMarks: sessionalMarks,
        finalMarks: finalMarks,
        totalMarks: sessionalMarks + finalMarks,
        grade: letterGrade,
        credithour: creditHour,
        gpa: calculatedGpa,
        status: isFailed ? 'Failed' : 'Passed',
        semester: semester,
        remarks: isFailed ? failureReason : null,
      );
    }).toList();

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Results'),
        backgroundColor: Get.theme.primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Get.theme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.class_, color: Get.theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  sectionClass,
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Obx(() => ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.submitCourseGrades(previousGrades),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8)),
                      child: controller.isSubmitting.value
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Submit',
                              style: TextStyle(color: Colors.white)),
                    ))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Get.theme.primaryColor.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Class Average', '${mean.toStringAsFixed(1)}%'),
                _buildStatItem(
                    'Standard Deviation', '${stdDev.toStringAsFixed(1)}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: previousGrades.length,
              itemBuilder: (context, index) {
                final grade = previousGrades[index];
                final isFailed = grade.status == 'Failed';
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Student ID: ${grade.studentId}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getGradeColor(grade.grade)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getGradeColor(grade.grade),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                grade.grade,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getGradeColor(grade.grade),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isFailed && grade.remarks != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.warning,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  grade.remarks!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sessional Marks',
                              style: TextStyle(color: Get.theme.primaryColor),
                            ),
                            Text(
                              '${grade.sessionalMarks.toStringAsFixed(1)}/50',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (grade.sessionalMarks < 25)
                                    ? Colors.red
                                    : Get.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Final Marks',
                              style: TextStyle(color: Get.theme.primaryColor),
                            ),
                            Text(
                              '${grade.finalMarks.toStringAsFixed(1)}/50', // You may want to show max marks if available
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (grade.finalMarks < 25)
                                    ? Colors.red
                                    : Get.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            Text(
                              '${grade.totalMarks.toStringAsFixed(1)}/100',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(grade.grade),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'GPA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            Text(
                              grade.gpa.toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(grade.grade),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Get.theme.primaryColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Get.theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
