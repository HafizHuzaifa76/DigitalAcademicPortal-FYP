import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/DepartmentController.dart';


class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    final DepartmentController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          else {
            if (controller.departmentList.isEmpty) {
              return Center(child: Text("No departments available"));
            } else {
              return ListView.builder(
                itemCount: controller.departmentList.length,
                itemBuilder: (context, index) {
                  final department = controller.departmentList[index];
                  return ListTile(
                    title: Text(department.departmentName),
                    subtitle: Text(
                        'Code: ${department.departmentCode}, HOD: ${department.headOfDepartment}'),
                    onTap: () {
                      // Handle tap, e.g., navigate to department details or edit
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
