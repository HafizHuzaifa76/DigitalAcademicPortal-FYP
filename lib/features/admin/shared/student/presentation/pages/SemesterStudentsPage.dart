import 'package:digital_academic_portal/features/admin/shared/student/presentation/pages/StudentDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../domain/entities/Student.dart';
import '../controllers/StudentController.dart';

class SemesterStudentsPage extends StatefulWidget {
  final String deptName;
  final String semester;

  const SemesterStudentsPage({super.key, required this.deptName, required this.semester});

  @override
  State<SemesterStudentsPage> createState() => _SemesterStudentsPageState();
}

class _SemesterStudentsPageState extends State<SemesterStudentsPage> {
  final StudentController controller = Get.find();
  final addStudentKey = GlobalKey<FormState>();
  final editStudentKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.showSemesterStudents(widget.deptName, widget.semester);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          // IconButton(
          //     onPressed: ()=> addStudentDialog(context),
          //     icon: Icon(Icons.add)
          // )
        ],
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
