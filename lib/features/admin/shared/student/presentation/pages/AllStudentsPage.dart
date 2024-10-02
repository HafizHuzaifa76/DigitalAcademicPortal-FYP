import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/StudentController.dart';
import 'StudentDetailPage.dart';

class AllStudentsPage extends StatefulWidget {

  const AllStudentsPage({super.key});

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  final StudentController controller = Get.find();

  @override
  void initState() {
    controller.showAllStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 100,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          }
          else {
            if (controller.studentList.isEmpty) {
              return const Center(child: Text("No Students available"));
            } else {
              return ListView.builder(
                itemCount: controller.studentList.length,
                itemBuilder: (context, index) {
                  final student = controller.studentList[index];
                  return ListTile(
                    title: Text(student.studentRollNo),
                    subtitle: Text(
                        'name: ${student.studentName}, father: ${student.fatherName}'),
                    onTap: () {
                      Get.to(StudentDetailPage(student: student));
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
