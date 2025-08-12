import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AdminReportController.dart';
import '../bindings/AdminReportBinding.dart';

class AdminReportsPage extends StatelessWidget {
  AdminReportsPage({super.key}) {
    AdminReportBinding().dependencies();
  }

  final AdminReportController controller = Get.find<AdminReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Issue Reports'),
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
        if (controller.reports.isEmpty) {
          return const Center(
            child: Text('No unresponded reports.'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final report = controller.reports[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Get.theme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Roll No: ${report.studentRollNo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.reply_rounded),
                        label: const Text('Respond'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showRespondDialog(context, report.id),
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

  void _showRespondDialog(BuildContext context, String reportId) {
    final TextEditingController responseController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respond to Report'),
        content: TextField(
          controller: responseController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your response...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final response = responseController.text.trim();
              if (response.isNotEmpty) {
                await controller.respondToReport(reportId, response);
                Navigator.of(context).pop();
                Get.snackbar('Success', 'Response sent!',
                    backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
