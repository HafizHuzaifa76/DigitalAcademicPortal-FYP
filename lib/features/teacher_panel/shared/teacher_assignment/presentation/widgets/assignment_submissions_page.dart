import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/Assignment.dart';

class AssignmentSubmissionsPage extends StatelessWidget {
  final Assignment assignment;
  const AssignmentSubmissionsPage({Key? key, required this.assignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Submissions',
            style:
                TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: assignment.studentAssignments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final studentId = assignment.studentAssignments.keys.elementAt(index);
          final submission = assignment.studentAssignments[studentId]!;
          return Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.person_rounded,
                      color: theme.primaryColor, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      studentId,
                      style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  if (submission == 'Not Submitted')
                    Text('Not Submitted',
                        style: TextStyle(
                            color: Colors.red[600],
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500))
                  else
                    IconButton(
                      icon: Icon(Icons.link, color: theme.primaryColor),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final url = Uri.parse(submission);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar(
                              'Error', 'Could not open submission URL');
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
