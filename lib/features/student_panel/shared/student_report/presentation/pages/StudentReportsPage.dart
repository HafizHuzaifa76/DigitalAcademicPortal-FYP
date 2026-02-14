import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/StudentReportController.dart';

class StudentReportsPage extends StatelessWidget {
  const StudentReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentReportController>();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Reports"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Obx(() => TextFormField(
                    initialValue: controller.message.value,
                    maxLines: 3,
                    onChanged: (val) => controller.message.value = val,
                    decoration: InputDecoration(
                      labelText: 'Describe your issue',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Message required'
                        : null,
                  )),
            ),
            const SizedBox(height: 12),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.submitReport();
                            }
                          },
                  ),
                )),
            const SizedBox(height: 24),
            Expanded(
                child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.reports.isEmpty
                      ? const Center(child: Text('No previous reports.'))
                      : ListView.separated(
                          itemCount: controller.reports.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final report = controller.reports[i];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      report.message,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Ubuntu',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      report.response == null ||
                                              report.response!.isEmpty
                                          ? 'No response yet'
                                          : 'Response: ${report.response}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: report.response == null
                                            ? Colors.grey
                                            : Theme.of(context).primaryColor,
                                        fontFamily: 'Ubuntu',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            )),
          ],
        ),
      ),
    );
  }
}
