import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/StudentCourse.dart';
import '../controllers/StudentUploadedFileController.dart';
import '../../domain/entities/UploadedFile.dart';
import '../bindings/StudentUploadedFileBinding.dart';

class StudentCourseMaterialsTab extends StatelessWidget {
  final StudentCourse course;
  const StudentCourseMaterialsTab({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Course Materials'),
        const SizedBox(height: 20),
        _buildMaterialCard(
          'Lecture Slides',
          'Access and view ${course.courseCode} lecture presentations',
          Icons.slideshow_outlined,
          () => Get.to(() => LectureSlidesScreen(course: course),
              binding: StudentUploadedFileBinding()),
        ),
        const SizedBox(height: 12),
        _buildMaterialCard(
          'Resources',
          'Additional learning materials for ${course.courseName}',
          Icons.folder_outlined,
          () => Get.to(() => ResourcesScreen(course: course),
              binding: StudentUploadedFileBinding()),
        ),
        const SizedBox(height: 12),
        _buildMaterialCard(
          'Syllabus',
          'Course outline and learning objectives',
          Icons.description_outlined,
          () => Get.to(() => SyllabusScreen(course: course),
              binding: StudentUploadedFileBinding()),
        ),
      ],
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

class LectureSlidesScreen extends StatelessWidget {
  final StudentCourse course;
  const LectureSlidesScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(StudentUploadedFileController(getFilesUseCase: Get.find()));
    controller.getFiles(course.courseDept, course.courseSemester,
        course.courseName, course.courseSection, FileType.lectureSlide);
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture Slides')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.files.isEmpty) {
          return const Center(child: Text('No lecture slides found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.files.length,
          itemBuilder: (context, index) {
            final file = controller.files[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf,
                    color: Colors.red, size: 32),
                title: Text(file.fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  onPressed: () {
                    // TODO: Implement file download/open
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class ResourcesScreen extends StatelessWidget {
  final StudentCourse course;
  const ResourcesScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(StudentUploadedFileController(getFilesUseCase: Get.find()));
    controller.getFiles(course.courseDept, course.courseSemester,
        course.courseName, course.courseSection, FileType.resource);
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.files.isEmpty) {
          return const Center(child: Text('No resources found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.files.length,
          itemBuilder: (context, index) {
            final file = controller.files[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf,
                    color: Colors.red, size: 32),
                title: Text(file.fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  onPressed: () {
                    // TODO: Implement file download/open
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class SyllabusScreen extends StatelessWidget {
  final StudentCourse course;
  const SyllabusScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(StudentUploadedFileController(getFilesUseCase: Get.find()));
    controller.getFiles(course.courseDept, course.courseSemester,
        course.courseName, course.courseSection, FileType.syllabus);
    return Scaffold(
      appBar: AppBar(title: const Text('Syllabus')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.files.isEmpty) {
          return const Center(child: Text('No syllabus files found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.files.length,
          itemBuilder: (context, index) {
            final file = controller.files[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf,
                    color: Colors.red, size: 32),
                title: Text(file.fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  onPressed: () {
                    // TODO: Implement file download/open
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
