import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/StudentCourse.dart';

class StudentAnnouncementsTab extends StatelessWidget {
  final StudentCourse course;
  const StudentAnnouncementsTab({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final announcements = [
      {
        'title': 'Class Cancelled',
        'description': 'Tomorrow\'s class is cancelled due to unforeseen circumstances.',
        'date': '2024-05-10',
        'teacher': course.teacherName,
        'details': 'Please check the portal for further updates. The next class will be held as per schedule.',
        'attachment': 'No attachment',
      },
      {
        'title': 'Assignment 2 Released',
        'description': 'Assignment 2 is now available on the portal. Submit by next Friday.',
        'date': '2024-05-08',
        'teacher': course.teacherName,
        'details': 'Assignment covers chapters 3 and 4. Late submissions will not be accepted.',
        'attachment': 'Assignment2.pdf',
      },
      {
        'title': 'Quiz Reminder',
        'description': 'Quiz 1 will be held on Monday during class hours.',
        'date': '2024-05-05',
        'teacher': course.teacherName,
        'details': 'Quiz will be based on lectures 1-5. Bring your own stationery.',
        'attachment': 'QuizSyllabus.pdf',
      },
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Announcements'),
        const SizedBox(height: 16),
        ...announcements.map((a) => _buildAnnouncementCard(context, a)).toList(),
      ],
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

  Widget _buildAnnouncementCard(BuildContext context, Map<String, String> announcement) {
    return InkWell(
      onTap: () => Get.to(() => AnnouncementDetailScreen(announcement: announcement)),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        shadowColor: Get.theme.primaryColor.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.announcement, color: Get.theme.primaryColor, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      announcement['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(
                    announcement['date'] ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                announcement['description'] ?? '',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 18, color: Get.theme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    announcement['teacher'] ?? '',
                    style: TextStyle(fontSize: 14, color: Get.theme.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnouncementDetailScreen extends StatelessWidget {
  final Map<String, String> announcement;
  const AnnouncementDetailScreen({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(announcement['title'] ?? 'Announcement')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
          shadowColor: Get.theme.primaryColor.withOpacity(0.18),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.announcement, color: Get.theme.primaryColor, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        announcement['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  announcement['description'] ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Get.theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      announcement['teacher'] ?? '',
                      style: TextStyle(fontSize: 15, color: Get.theme.primaryColor, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      announcement['date'] ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Get.theme.primaryColor),
                ),
                const SizedBox(height: 6),
                Text(
                  announcement['details'] ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 18),
                if ((announcement['attachment'] ?? '').isNotEmpty && announcement['attachment'] != 'No attachment')
                  Row(
                    children: [
                      Icon(Icons.attach_file, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        announcement['attachment'] ?? '',
                        style: const TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 