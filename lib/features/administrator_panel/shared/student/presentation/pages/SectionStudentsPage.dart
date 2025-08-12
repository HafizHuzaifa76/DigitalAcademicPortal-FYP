import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/presentation/pages/StudentDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../shared/domain/entities/Student.dart';
import '../controllers/StudentController.dart';

class SectionStudentsPage extends StatefulWidget {
  final String deptName;
  final String semester;
  final String section;

  const SectionStudentsPage(
      {super.key,
      required this.deptName,
      required this.semester,
      required this.section});

  @override
  State<SectionStudentsPage> createState() => _SectionStudentsPageState();
}

class _SectionStudentsPageState extends State<SectionStudentsPage> {
  final StudentController controller = Get.find();

  @override
  void initState() {
    controller.deptName = widget.deptName;
    controller.showSectionStudents(widget.semester, widget.section);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 90),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Section Students',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                        '${widget.deptName.trim()} - ${widget.section}',
                        maxLines: 1,
                        maxFontSize: 14,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (query) {
                              controller.filterStudents(query);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              hintText: 'Search students...',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/loading_animation4.json',
                        width: 120,
                        height: 120,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading students...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (controller.filteredStudentList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No students available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add your first student to get started",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final student = controller.filteredStudentList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Get.to(StudentDetailPage(student: student));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.studentRollNo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: 'Ubuntu',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Name: ${student.studentName}\nFather: ${student.fatherName}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                              fontFamily: 'Ubuntu',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: controller.filteredStudentList.length,
                    ),
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }
}
