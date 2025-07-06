import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_assignment/presentation/widgets/add_assignment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherAssignmentController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

// Add import for the new submissions page
import '../widgets/assignment_submissions_page.dart';

class TeacherAssignmentPage extends GetView<TeacherAssignmentController> {
  const TeacherAssignmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, const Color(0xFF1B7660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Assignments',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.isCourseLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Select Course',
                      border: InputBorder.none,
                    ),
                    value: controller.selectedCourse.value,
                    items: controller.coursesList.map((course) {
                      return DropdownMenuItem(
                        value: course,
                        child: Text(course.courseName,
                            style: const TextStyle(fontFamily: 'Ubuntu')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.onCourseSelected(value);
                      }
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.selectedCourse.value == null) {
                  return Center(
                    child: Text(
                      'Please select a course to see assignments.',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                if (controller.assignments.isEmpty) {
                  return Center(
                    child: Text(
                      'No assignments found for this course.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.assignments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final assignment = controller.assignments[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assignment_rounded,
                                    color: theme.primaryColor, size: 28),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    assignment.title,
                                    style: const TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.link,
                                      color: theme.primaryColor),
                                  onPressed: () async {
                                    final url = Uri.parse(assignment.fileUrl);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      Get.snackbar(
                                          'Error', 'Could not open file URL');
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              assignment.description,
                              style: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Show deadline
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: theme.primaryColor, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Deadline: ${DateFormat.yMMMd().format(assignment.dueDate)}',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // View Submissions button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(Icons.people_alt_rounded,
                                    color: theme.primaryColor),
                                label: Text(
                                  'View Submissions',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: theme.primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => AssignmentSubmissionsPage(
                                      assignment: assignment));
                                },
                              ),
                            ),
                          ],
                        ),
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
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          if (controller.selectedCourse.value != null) {
            showAddAssignmentBottomSheet(context);
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
