import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Department.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/DepartmentController.dart';

class SemesterPage extends StatefulWidget {
  final Department department;
  final String semester;
  const SemesterPage(
      {super.key, required this.department, required this.semester});

  @override
  State<SemesterPage> createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  @override
  Widget build(BuildContext context) {
    var dept = widget.department;
    var semester = widget.semester;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: Stack(
            children: [
                  Positioned(
                    bottom: 78,
                    left: 65,
                    right: 65,
                    child: Text(
                      '${dept.departmentName}\n$semester',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 80,
                      height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Stats cards
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            icon: Icons.book_rounded,
                            title: 'Courses',
                            value: '${dept.totalSemesters}',
                            color: Colors.white,
                          ),
                          _buildStatCard(
                            icon: Icons.person_rounded,
                            title: 'Teachers',
                            value: '${dept.totalTeachers}',
                            color: Colors.white,
                          ),
                          _buildStatCard(
                            icon: Icons.people_rounded,
                            title: 'Students',
                            value: '${dept.totalStudents}',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                            ),
                          ),
                        ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
                            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                  // Department Info Cards
                  Container(
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
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semester Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.code_rounded,
                                title: 'Department Code',
                                value: dept.departmentCode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.person_rounded,
                                title: 'Head of Department',
                                value: dept.headOfDepartment,
                          ),
                        ),
                      ],
                    ),
                        const SizedBox(height: 12),
                    Row(
                      children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.account_tree_rounded,
                                title: 'Sections',
                                value: '0',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.schedule_rounded,
                                title: 'Total Semesters',
                                value: '${dept.totalSemesters}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons grid
                  Column(
                    children: [
                      // First row (3 items)
                    Row(
                      children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: FontAwesomeIcons.userGraduate,
                              title: 'Students',
                              onTap: () =>
                                  Get.toNamed('/semesterStudents', arguments: {
                            'deptName': dept.departmentName,
                            'semester': semester,
                          }),
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.school_rounded,
                              title: 'Teachers',
                              onTap: () => Get.toNamed('/teachers'),
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.book_rounded,
                              title: 'Courses',
                              onTap: () => Get.toNamed('/semesterCourses',
                                  arguments: {
                            'deptName': dept.departmentName,
                            'semester': semester
                          }),
                              color: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                      const SizedBox(height: 8),
                      // Second row (2 items) - centered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 56) / 3,
                            child: _buildActionButton(
                              icon: Icons.account_tree_rounded,
                              title: 'Sections',
                              onTap: () => Get.toNamed('/allSections',
                                  arguments: {
                              'deptName': dept.departmentName,
                              'semester': semester
                            }),
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 56) / 3,
                            child: _buildActionButton(
                              icon: Icons.event_note_rounded,
                              title: 'Time Table',
                              onTap: () => Get.toNamed('/semesterTimeTablePage',
                                  arguments: {
                              'deptName': dept.departmentName,
                              'semester': semester
                            }),
                              color: Get.theme.primaryColor,
                            ),
                          ),
                        ],
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Ubuntu',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontFamily: 'Ubuntu',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontFamily: 'Ubuntu',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
