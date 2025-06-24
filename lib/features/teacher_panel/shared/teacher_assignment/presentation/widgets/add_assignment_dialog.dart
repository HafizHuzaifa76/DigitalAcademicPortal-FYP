import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_assignment/presentation/controllers/TeacherAssignmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddAssignmentDialog extends StatelessWidget {
  final TeacherAssignmentController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  AddAssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Assignment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  selectedDate.value == null
                      ? 'No due date selected'
                      : 'Due Date: ${DateFormat.yMd().format(selectedDate.value!)}',
                )),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  selectedDate.value = picked;
                }
              },
              child: const Text('Select Due Date'),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  controller.pickedFile.value == null
                      ? 'No file selected'
                      : 'File: ${controller.pickedFile.value!.path.split('/').last}',
                )),
            ElevatedButton(
              onPressed: () {
                controller.pickFile();
              },
              child: const Text('Pick File'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clearPickedFile();
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty &&
                selectedDate.value != null) {
              controller.createAssignment(
                title: titleController.text,
                description: descriptionController.text,
                dueDate: selectedDate.value!,
              );
            } else {
              Get.snackbar(
                'Error',
                'Please fill all fields and select a due date.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
