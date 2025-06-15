import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/ClassOverviewScreen.dart';

class StudentListTab extends StatelessWidget {
  final dynamic course;

  const StudentListTab({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Enrolled Students'),
          const SizedBox(height: 20),
          _buildStudentCard(
            'Class Overview',
            'Section ${course.courseSection} • ${course.courseCode}',
            Icons.group_outlined,
            '45 Students',
            () => Get.to(() => ClassOverviewScreen(course: course)),
          ),
          const SizedBox(height: 12),
          _buildStudentCard(
            'Attendance Record',
            'Track ${course.courseSection} attendance',
            Icons.calendar_today_outlined,
            '85% Average',
            () {},
          ),
          const SizedBox(height: 12),
          _buildStudentCard(
            'Grade Management',
            'Manage ${course.courseName} grades',
            Icons.grade_outlined,
            'View Progress',
            () {},
          ),
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

  Widget _buildStudentCard(String title, String subtitle, IconData icon, String status, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Get.theme.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status,
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 