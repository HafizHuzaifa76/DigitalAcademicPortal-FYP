import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '';
import '../pages/DiscussionForumScreen.dart';
import '../pages/PendingQueriesScreen.dart';
class StudentQueriesTab extends StatelessWidget {
  final dynamic course;

  const StudentQueriesTab({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Pending Queries'),
          _buildQueryCard(
            'Pending Queries',
            'View and answer student queries',
            'Pending',
            Icons.help_outline,
            Colors.orange,
            () => Get.to(() => PendingQueriesScreen(course: course)),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Discussion Forum'),
          _buildQueryCard(
            'Discussion Forum',
            'Open chatroom for course discussions',
            'Open',
            Icons.forum_outlined,
            Colors.blue,
            () => Get.to(() => DiscussionForumScreen(course: course)),
          ),
        ],
      ),
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

  Widget _buildQueryCard(String title, String subtitle, String status, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
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
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 