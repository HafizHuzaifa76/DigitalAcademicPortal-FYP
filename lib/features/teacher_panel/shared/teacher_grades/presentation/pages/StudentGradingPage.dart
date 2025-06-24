import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherGradeController.dart';
import '../../domain/entities/Grade.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';

class StudentGradingPage extends StatefulWidget {
  final Grade grade;

  const StudentGradingPage({
    super.key,
    required this.grade,
  });

  @override
  State<StudentGradingPage> createState() => _StudentGradingPageState();
}

class _StudentGradingPageState extends State<StudentGradingPage> {
  final TeacherGradeController controller = Get.find();
  final Map<String, TextEditingController> gradeControllers = {};
  final _formKey = GlobalKey<FormState>();
  final RxBool _hasUnsavedChanges = false.obs;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with student IDs and their marks
    for (var entry in widget.grade.obtainedMarks.entries) {
      gradeControllers[entry.key] = TextEditingController(
        text: _formatNumber(entry.value),
      );
      // Add listener to detect changes
      gradeControllers[entry.key]!.addListener(_onMarksChanged);
    }
  }

  void _onMarksChanged() {
    if (!_hasUnsavedChanges.value) {
      _hasUnsavedChanges.value = true;
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges.value) return true;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: TextStyle(color: Get.theme.primaryColor),
        ),
        content: const Text(
            'You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false); // Don't save
            },
            child: Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true); // Save
            },
            child: Text(
              'Save',
              style: TextStyle(color: Get.theme.primaryColor),
            ),
          ),
        ],
      ),
    );

    if (result == null) return false; // User cancelled
    if (result) {
      await _saveGrades();
    }
    return true;
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    final num = double.tryParse(value.toString()) ?? 0;
    return num == num.toInt() ? num.toInt().toString() : num.toString();
  }

  String? _validateMarks(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty';
    }

    final marks = double.tryParse(value);
    if (marks == null) {
      return 'Invalid';
    }

    if (marks < 0) {
      return 'Invalid';
    }

    if (marks > widget.grade.totalMarks) {
      return 'Limit Exceed';
    }

    return null;
  }

  @override
  void dispose() {
    for (var controller in gradeControllers.values) {
      controller.removeListener(_onMarksChanged);
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveGrades() async {
    if (!_formKey.currentState!.validate()) {
      Utils().showErrorSnackBar('Error', 'Please fix the errors before saving');
      return;
    }

    final marks = <String, dynamic>{};
    for (var entry in gradeControllers.entries) {
      marks[entry.key] = double.tryParse(entry.value.text) ?? 0;
    }

    await controller.saveGrades(widget.grade, marks);
    _hasUnsavedChanges.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.grade.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Get.back();
              }
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.grade.obtainedMarks.isEmpty) {
            return const Center(child: Text('No students found'));
          }

          return Form(
            key: _formKey,
            child: ListView.builder(
              itemCount: widget.grade.obtainedMarks.length,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) {
                // Sort the entries by student ID
                final sortedEntries = widget.grade.obtainedMarks.entries
                    .toList()
                  ..sort((a, b) => a.key.compareTo(b.key));
                final studentId = sortedEntries[index].key;
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Get.theme.primaryColor.withOpacity(0.1),
                              child: Text(
                                studentId[0].toUpperCase(),
                                style: TextStyle(
                                  color: Get.theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    studentId,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Student ID',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                controller: gradeControllers[studentId],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: _validateMarks,
                                decoration: InputDecoration(
                                  hintText: 'Marks',
                                  suffixText: '/${widget.grade.totalMarks}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorStyle: const TextStyle(fontSize: 10),
                                ),
                                onChanged: (value) {
                                  _formKey.currentState!.validate();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveGrades,
          backgroundColor: Get.theme.primaryColor,
          child: const Icon(Icons.save, color: Colors.white),
        ),
      ),
    );
  }
}
