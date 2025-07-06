import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../controllers/TeacherCourseController.dart';

class StudentListTab extends StatefulWidget {
  final TeacherCourse course;

  const StudentListTab({
    super.key,
    required this.course,
  });

  @override
  State<StudentListTab> createState() => _StudentListTabState();
}

class _StudentListTabState extends State<StudentListTab> {
  late TeacherCourseController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TeacherCourseController>();
    // Fetch student names when the tab is loaded
    if (widget.course.studentIds.isNotEmpty && controller.studentNames.isEmpty) {
      controller.fetchStudentNames(widget.course.studentIds, widget.course.courseDept);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Enrolled Students'),
          const SizedBox(height: 20),
          if (widget.course.studentIds.isEmpty)
            _buildEmptyState()
          else
            _buildStudentList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.primaryColor.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No students enrolled yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Students will appear here once they are enrolled',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return Obx(() {
      if (controller.isLoadingStudentNames.value) {
        return Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading student names...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Students: ${widget.course.studentIds.length}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.course.studentIds.length,
            itemBuilder: (context, index) {
              final studentId = widget.course.studentIds[index];
              final studentName =
                  controller.studentNames[studentId] ?? 'Loading...';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Roll Number: $studentId',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(
                    Icons.person_outline,
                    color: Get.theme.primaryColor,
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
