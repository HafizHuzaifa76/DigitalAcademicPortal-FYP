import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TeacherController.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    final TeacherController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
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
