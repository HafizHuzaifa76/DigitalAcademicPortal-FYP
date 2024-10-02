import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/TeacherController.dart';

class DeptTeacherPage extends StatefulWidget {
  final String deptName;
  const DeptTeacherPage({super.key, required this.deptName});

  @override
  State<DeptTeacherPage> createState() => _DeptTeacherPageState();
}

class _DeptTeacherPageState extends State<DeptTeacherPage> {
  final TeacherController controller = Get.find();

  @override
  void initState() {
    controller.showDeptTeachers(widget.deptName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
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
            if (controller.teacherList.isEmpty) {
              return const Center(child: Text("No Teachers available"));
            } else {
              return ListView.builder(
                itemCount: controller.teacherList.length,
                itemBuilder: (context, index) {
                  final teacher = controller.teacherList[index];
                  return ListTile(
                    title: Text(teacher.teacherName),
                    subtitle: const Text(''),
                    onTap: () {

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
