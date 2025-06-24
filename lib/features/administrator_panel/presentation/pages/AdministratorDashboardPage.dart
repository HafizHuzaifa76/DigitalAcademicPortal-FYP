import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/administrator_panel/presentation/widgets/AdministratorDrawer.dart';
import 'package:digital_academic_portal/features/administrator_panel/presentation/controllers/AdminDashboardController.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/CalendarPage.dart';
import 'package:digital_academic_portal/features/auth/presentation/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AdministratorDashboardPage extends StatefulWidget {
  const AdministratorDashboardPage({super.key});

  @override
  State<AdministratorDashboardPage> createState() =>
      _AdministratorDashboardPageState();
}

class _AdministratorDashboardPageState
    extends State<AdministratorDashboardPage> {
  final AdminDashboardController adminDashboardController =
      Get.find<AdminDashboardController>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const AdministratorDrawer(),
      body: RefreshIndicator(
        onRefresh: () async =>
            await adminDashboardController.loadDashboardStats(),
        child: CustomScrollView(
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
                              kIsWeb ? 'Administrator Dashboard' : 'Admin Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
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
                              icon: Icons.school_rounded,
                              title: 'Departments',
                              value: adminDashboardController
                                  .departmentsCount.value
                                  .toString(),
                              isLoading:
                                  adminDashboardController.isLoading.value,
                              hasError: adminDashboardController.hasError,
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.person_rounded,
                              title: 'Teachers',
                              value: adminDashboardController
                                  .teachersCount.value
                                  .toString(),
                              isLoading:
                                  adminDashboardController.isLoading.value,
                              hasError: adminDashboardController.hasError,
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.people_rounded,
                              title: 'Students',
                              value: adminDashboardController
                                  .studentsCount.value
                                  .toString(),
                              isLoading:
                                  adminDashboardController.isLoading.value,
                              hasError: adminDashboardController.hasError,
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
                                icon: 'assets/images/department_icon.png',
                                title: 'Departments',
                                onTap: () => Get.toNamed('/departments'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                icon: 'assets/images/students_icon.png',
                                title: 'Students',
                                onTap: () => Get.toNamed('/allStudents'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                icon: 'assets/images/th1.png',
                                title: 'Teachers',
                                onTap: () => Get.toNamed('/allTeachers'),
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
                                icon: 'assets/images/admin.png',
                                title: 'Sub Admins',
                                onTap: () => Get.toNamed('/allCourses'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                icon: 'assets/images/noticeboard_icon.png',
                                title: 'Notice Board',
                                onTap: () => Get.toNamed('/mainNoticeBoard'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                icon: 'assets/images/calendar_icon.png',
                                title: 'Calendar',
                                onTap: () => Get.toNamed('/calendarPage'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Third row (2 items) - centered
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 56) /
                                  3, // Same width as other items
                              child: _buildActionButton(
                                icon: 'assets/images/chatbot_icon.png',
                                title: 'ChatBot',
                                onTap: () => Get.toNamed('/'),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 56) /
                                  3, // Same width as other items
                              child: _buildActionButton(
                                icon: 'assets/images/bugreport_icon.png',
                                title: 'Reports',
                                onTap: () => Get.toNamed('/'),
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
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isLoading,
    required bool hasError,
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
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 2,
              ),
            )
          else if (hasError)
            Icon(
              Icons.error_outline_rounded,
              color: color,
              size: 24,
            )
          else
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
                          const Text(
                            'Hi, Hafiz!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          Text(
                            'hafizm.huzaifa1234gf@gmail.com',
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
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.back();
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
