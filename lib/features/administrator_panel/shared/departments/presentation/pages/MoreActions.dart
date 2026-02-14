import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreActionsPage extends StatefulWidget {
  const MoreActionsPage({Key? key}) : super(key: key);

  @override
  State<MoreActionsPage> createState() => _MoreActionsPageState();
}

class _MoreActionsPageState extends State<MoreActionsPage> {
  bool expandMoveStudents = false;

  final Color primaryColor = const Color(0xFF2C5D3B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildActionTile(
              icon: Icons.file_copy,
              title: 'Add Personal Template for Transcript',
              subtitle: 'Upload or create a transcript template for a student',
              color: Colors.blue,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.arrow_upward,
              title: 'Move Students to Next Semester',
              subtitle: 'Promote students (8th → graduated, etc.)',
              color: Colors.green,
              onTap: () {
                setState(() {
                  expandMoveStudents = !expandMoveStudents;
                });
              },
            ),
            if (expandMoveStudents) _buildMoveStudentsOptions(),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.lock,
              title: 'Freeze Students',
              subtitle: 'Temporarily freeze selected students',
              color: Colors.orange,
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.refresh,
              title: 'Repeaters Functionality',
              subtitle: 'Mark students who need to repeat subjects',
              color: Colors.purple,
              onTap: () => _showComingSoon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C5D3B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expandMoveStudents &&
                          title == "Move Students to Next Semester"
                      ? Icons.expand_less
                      : Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoveStudentsOptions() {
    final promotions = [
      "SEM-VIII → Graduated",
      "SEM-VII → SEM-VIII",
      "SEM-VI → SEM-VII",
      "SEM-V → SEM-VI",
      "SEM-IV → SEM-V",
      "SEM-III → SEM-IV",
      "SEM-II → SEM-III",
      "SEM-I → SEM-II",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow.shade700),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Promotion Instructions:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "1. Ensure all courses for the students’ current semester are fully submitted.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                "2. The target semester must have no existing students.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                "3. Promote in downward order: start from the highest semester that will be emptied, then continue downward.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),

        // Promotion Options
        ...promotions.map((p) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => _showPromotionConfirmation(p),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  p,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

// Confirmation dialog before moving students
  void _showPromotionConfirmation(String semester) {
    Get.defaultDialog(
      title: "Confirm Promotion",
      middleText: "Are you sure you want to move students to $semester?",
      textCancel: "Cancel",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close confirmation dialog
        _simulateLoading(semester); // Proceed with promotion
      },
    );
  }

  void _showComingSoon() {
    Get.snackbar(
      'Coming Soon',
      'This feature will be implemented soon.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  void _simulateLoading(String semester) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    if (semester == '1st → 2nd' || semester == '3rd → 4th') {
      await Future.delayed(const Duration(seconds: 8));

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Some Students Courses are not submitted completely',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    } else {
      await Future.delayed(const Duration(seconds: 3));

      Get.back(); // Close loading dialog
      Get.snackbar(
        'No Data',
        'No student exist.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    }
  }
}
