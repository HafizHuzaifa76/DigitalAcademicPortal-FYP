import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../pages/LectureSlidesScreen.dart';
import '../pages/ResourcesScreen.dart';
import '../pages/SyllabusScreen.dart';

class CourseMaterialsTab extends StatelessWidget {
  final TeacherCourse course;

  const CourseMaterialsTab({
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
          _buildSectionHeader('Course Materials'),
          const SizedBox(height: 20),
          _buildMaterialCard(
            'Lecture Slides',
            'Access and manage ${course.courseCode} lecture presentations',
            Icons.slideshow_outlined,
            () => Get.to(() => LectureSlidesScreen(course: course)),
          ),
          const SizedBox(height: 12),
          _buildMaterialCard(
            'Resources',
            'Additional learning materials for ${course.courseName}',
            Icons.folder_outlined,
            () => Get.to(() => ResourcesScreen(course: course)),
          ),
          const SizedBox(height: 12),
          _buildMaterialCard(
            'Syllabus',
            'Course outline and learning objectives',
            Icons.description_outlined,
            () => Get.to(() => SyllabusScreen(course: course)),
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

  Widget _buildMaterialCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
