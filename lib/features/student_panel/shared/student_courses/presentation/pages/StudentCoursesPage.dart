import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/StudentCoursesController.dart';
import 'StudentCourseDetailsPage.dart';

class StudentCoursesPage extends StatefulWidget {
  final String studentDept;
  final int? detailPage;
  const StudentCoursesPage(
      {required this.studentDept, Key? key, this.detailPage})
      : super(key: key);

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  final StudentCoursesController controller = Get.find();

  @override
  void initState() {
    controller.fetchStudentCourses(widget.studentDept);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.detailPage == null ? 'My Courses' : 'Select Course'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor,
                const Color(0xFF1B7660),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coursesList.isEmpty) {
          return const Center(child: Text('No courses found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.coursesList.length,
          itemBuilder: (context, index) {
            final course = controller.coursesList[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => StudentCourseDetailsPage(
                      course: course,
                      detailPage: widget.detailPage,
                    ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.book,
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.courseName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                Text(
                                  course.courseCode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.person,
                            'Teacher',
                            course.teacherName,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.group,
                            'Section',
                            course.courseSection,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.school,
                            'Credit Hours',
                            course.courseCreditHours.toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.category,
                            'Type',
                            course.courseType,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Get.theme.primaryColor.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
