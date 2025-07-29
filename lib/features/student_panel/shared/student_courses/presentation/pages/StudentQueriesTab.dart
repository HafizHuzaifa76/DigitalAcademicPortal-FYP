import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import '../../domain/entities/StudentCourse.dart';
import '../controllers/StudentQueryController.dart';
import '../bindings/StudentQueryBinding.dart';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart'
    as student_query_entity;
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentQueriesTab extends StatelessWidget {
  final StudentCourse course;
  const StudentQueriesTab({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentQueryController>(
      init: Get.put(StudentQueryController(getQueriesUseCase: Get.find(), askQueryUseCase: Get.find())),
      builder: (controller) {
        controller.fetchQueries(course.courseDept, course.courseSemester,
            course.courseName, course.courseSection);
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader('Pending Queries'),
              _buildQueryCard(
                'Pending Queries',
                'View and manage your pending queries',
                '${controller.pendingQueries.length} Pending',
                Icons.help_outline,
                Colors.orange,
                () => Get.to(() => PendingQueriesScreen(course: course),
                    binding: StudentQueryBinding()),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Responded Queries'),
              _buildQueryCard(
                'Responded Queries',
                'View queries that have been answered',
                '${controller.respondedQueries.length} Responded',
                Icons.check_circle_outline,
                Colors.green,
                () => Get.to(() => RespondedQueriesScreen(course: course),
                    binding: StudentQueryBinding()),
              ),
            ],
          );
        });
      },
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

  Widget _buildQueryCard(String title, String subtitle, String status,
      IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// Pending Queries Screen
class PendingQueriesScreen extends StatelessWidget {
  final StudentCourse course;
  PendingQueriesScreen({Key? key, required this.course})
      : super(key: key);

  final student = StudentPortalDashboardPage.studentProfile;

  void _showAskQuerySheet(
      BuildContext context, StudentQueryController controller) {
    final _formKey = GlobalKey<FormState>();
    String question = '';
    String description = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ask a New Query',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your question'
                      : null,
                  onSaved: (value) => question = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                  onSaved: (value) => description = value ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final query = student_query_entity.Query(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        studentID: student?.studentRollNo ?? '',
                        studentName: student?.studentName ?? '',
                        subject: question,
                        message: description,
                        status: 'pending',
                        createdDate: DateTime.now(),
                        response: null,
                        responseDate: null,
                      );
                      await controller.askQuery(
                        query,
                        course.courseDept,
                        course.courseSemester,
                        course.courseName,
                        course.courseSection,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Post Query',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentQueryController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Queries')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.pendingQueries.isEmpty) {
          return const Center(child: Text('No pending queries.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pendingQueries.length,
          itemBuilder: (context, index) {
            final query = controller.pendingQueries[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.orange),
                title: Text(query.subject,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(query.message),
                trailing: const Text('Pending',
                    style: TextStyle(color: Colors.orange)),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Get.theme.primaryColor,
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: const Text('Ask a New Query',
            style: TextStyle(color: Colors.white)),
        onPressed: () => _showAskQuerySheet(context, controller),
      ),
    );
  }
}

// Responded Queries Screen
class RespondedQueriesScreen extends StatelessWidget {
  final StudentCourse course;
  const RespondedQueriesScreen({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentQueryController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Responded Queries')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.respondedQueries.isEmpty) {
          return const Center(child: Text('No responded queries.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.respondedQueries.length,
          itemBuilder: (context, index) {
            final query = controller.respondedQueries[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(query.subject,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(query.message),
                    const SizedBox(height: 8),
                    if (query.response != null)
                      Text('Answer: ${query.response}',
                          style: const TextStyle(color: Colors.green)),
                  ],
                ),
                trailing: const Text('Responded',
                    style: TextStyle(color: Colors.green)),
              ),
            );
          },
        );
      }),
    );
  }
}

// Ask Query Screen
class AskQueryScreen extends StatefulWidget {
  @override
  State<AskQueryScreen> createState() => _AskQueryScreenState();
}

class _AskQueryScreenState extends State<AskQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  String question = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Query')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your question'
                    : null,
                onSaved: (value) => question = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Get.back(result: {
                      'question': question,
                      'description': description,
                    });
                  }
                },
                child: const Text('Post Query',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
