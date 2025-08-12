import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/entities/TeacherCourse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherCourseController.dart';
import '../widgets/CourseMaterialsTab.dart';
import '../widgets/StudentListTab.dart';
import '../widgets/StudentQueriesTab.dart';

class TeacherCourseDetailsPage extends StatefulWidget {
  final TeacherCourse course;
  final int? detailPage;

  const TeacherCourseDetailsPage({
    super.key,
    required this.course,
    this.detailPage,
  });

  @override
  State<TeacherCourseDetailsPage> createState() =>
      _TeacherCourseDetailsPageState();
}

class _TeacherCourseDetailsPageState extends State<TeacherCourseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TeacherCourseController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TeacherCourseController>();
    controller.selectedCourse = widget.course;
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.detailPage ?? 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.theme.primaryColor,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                widget.course.courseName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.course.courseCode,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.class_,
                        color: Get.theme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Section ${widget.course.courseSection}',
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_today,
                        color: Get.theme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.course.courseSemester,
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Get.theme.primaryColor,
                  indicatorWeight: 3,
                  labelColor: Get.theme.primaryColor,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.book),
                      text: 'Course Material',
                      height: 42,
                    ),
                    Tab(
                      icon: Icon(Icons.people),
                      text: 'Students',
                      height: 50,
                    ),
                    Tab(
                      icon: Icon(Icons.question_answer),
                      text: 'Queries',
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            CourseMaterialsTab(course: widget.course),
            StudentListTab(course: widget.course),
            StudentQueriesTab(course: widget.course),
          ],
        ),
      ),
    );
  }
}
