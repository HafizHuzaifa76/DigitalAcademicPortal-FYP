import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/StudentController.dart';


class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          else {
            if (controller.studentList.isEmpty) {
              return Center(child: Text("No Students available"));
            } else {
              return ListView.builder(
                itemCount: controller.studentList.length,
                itemBuilder: (context, index) {
                  final student = controller.studentList[index];
                  return ListTile(
                    title: Text(student.studentID),
                    subtitle: Text(
                        'name: ${student.studentName}, father: ${student.fatherName}'),
                    onTap: () {
                      // Handle tap, e.g., navigate to Student details or edit
                    },
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}
