import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_assignment/presentation/widgets/add_assignment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherAssignmentController.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherAssignmentPage extends GetView<TeacherAssignmentController> {
  const TeacherAssignmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.isCourseLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Select Course',
                  border: OutlineInputBorder(),
                ),
                value: controller.selectedCourse.value,
                items: controller.coursesList.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course.courseName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.onCourseSelected(value);
                  }
                },
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.selectedCourse.value == null) {
                  return const Center(
                      child:
                          Text('Please select a course to see assignments.'));
                }
                if (controller.assignments.isEmpty) {
                  return const Center(
                      child: Text('No assignments found for this course.'));
                }
                return ListView.builder(
                  itemCount: controller.assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = controller.assignments[index];
                    return ListTile(
                      title: Text(assignment.title),
                      subtitle: Text(assignment.description),
                      // a button to open assignment.fileUrl
                      trailing: IconButton(
                        icon: const Icon(Icons.link),
                        onPressed: () async {
                          final url = Uri.parse(assignment.fileUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            Get.snackbar('Error', 'Could not open file URL');
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.selectedCourse.value != null) {
            Get.dialog(AddAssignmentDialog());
          } else {
            Get.snackbar(
              'No Course Selected',
              'Please select a course before adding an assignment.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
