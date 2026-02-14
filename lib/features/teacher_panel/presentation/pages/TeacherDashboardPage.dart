import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/controllers/TeacherDashboardController.dart';
import 'package:digital_academic_portal/shared/domain/entities/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/TeacherDrawer.dart';

class TeacherDashboardPage extends StatefulWidget {
  static Teacher? teacherProfile;
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => TeacherDashboardPageState();
}

class TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final TeacherDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const TeacherDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.person_rounded, color: Colors.white),
                  onPressed: () => _showCustomMenu(context),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: const Stack(
                children: [
                  Positioned(
                    bottom: 90,
                    left: 50,
                    right: 50,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            kIsWeb ? 'Teacher Dashboard' : 'Teacher Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              background: Obx(
                () => Container(
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
                              icon: Icons.business_rounded,
                              title: 'Department',
                              value: controller.teacher.value?.teacherDept ??
                                  'N/A',
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.book_rounded,
                              title: 'Courses',
                              value: '2',
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.person_rounded,
                              title: 'Faculty Type',
                              value: controller.teacher.value?.teacherType ??
                                  'N/A',
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
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Title Section
                  Container(
                    padding: const EdgeInsets.all(24),
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
                      children: [
                        Image.asset(
                          'assets/images/DAP logo.png',
                          height: 95,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Digital',
                              style: TextStyle(
                                fontFamily: 'Belanosima',
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' Academic ',
                              style: TextStyle(
                                fontFamily: 'Belanosima',
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Portal',
                              style: TextStyle(
                                fontFamily: 'Belanosima',
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Action buttons grid
                  Column(
                    children: [
                      // First row (3 items)
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/attendanceB.png',
                              title: 'Attendance',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherAttendancePage',
                                      arguments: {
                                        'teacherDept': controller
                                                .teacher.value?.teacherDept ??
                                            ''
                                      });
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/timetablebg.png',
                              title: 'Time Table',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherTimetablePage',
                                      arguments: {
                                        'teacherCNIC': controller
                                                .teacher.value?.teacherCNIC ??
                                            ''
                                      });
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/gradesbg.png',
                              title: 'Assignments',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherAssignments');
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Second row (3 items)
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/course_icon.png',
                              title: 'Courses',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherCoursesPage',
                                      arguments: {
                                        'teacherDept': controller
                                                .teacher.value?.teacherDept ??
                                            ''
                                      });
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/noticeboard_icon.png',
                              title: 'Announcement',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherAnnouncement');
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: 'assets/images/calendar_icon.png',
                              title: 'Calendar',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/calendarViewPage');
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Third row (1 item) - centered
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 56) / 3,
                            child: _buildActionButton(
                              icon: 'assets/images/grades.png',
                              title: 'Assign Grades',
                              onTap: () {
                                if (controller.teacher.value != null) {
                                  Get.toNamed('/teacherGradePage', arguments: {
                                    'teacherDept':
                                        controller.teacher.value?.teacherDept ??
                                            ''
                                  });
                                } else {
                                  Utils().showErrorSnackBar('Error',
                                      'Teacher data not loaded. Please wait or refresh.');
                                }
                              },
                              color: Theme.of(context).primaryColor,
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
          AutoSizeText(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Ubuntu',
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
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

  Widget _buildActionButton({
    required String icon,
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
                child: Image.asset(
                  icon,
                  height: 45,
                  width: 45,
                ),
              ),
              const SizedBox(height: 4),
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

  void _showCustomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${controller.teacher.value?.teacherName ?? 'Loading...'}!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          Text(
                            controller.teacher.value?.teacherEmail ??
                                'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      Get.back();
                      await FirebaseAuth.instance.signOut();
                      Get.offNamed('/login');
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
