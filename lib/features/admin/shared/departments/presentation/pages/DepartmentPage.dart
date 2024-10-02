import 'package:digital_academic_portal/features/admin/shared/departments/presentation/pages/DepartmentDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../domain/entities/Department.dart';
import '../controllers/DepartmentController.dart';


class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final DepartmentController controller = Get.find();
  final addDeptKey = GlobalKey<FormState>();
  final editDeptKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
        actions: [
          IconButton(
              onPressed: () => addDepartmentDialog(context),
              icon: const Icon(Icons.add, size: 25)
          )
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
            if (controller.departmentList.isEmpty) {
              return const Center(child: Text("No departments available"));
            } else {
              return ListView.builder(
                itemCount: controller.departmentList.length,
                itemBuilder: (context, index) {
                  final department = controller.departmentList[index];
                  return Card(
                    borderOnForeground: true,
                    shape: Border.all(color: Theme.of(context).primaryColor),
                    child: ListTile(
                      title: Text(department.departmentName),
                      subtitle: Text(
                          'Code: ${department.departmentCode}, HOD: ${department.headOfDepartment}'),
                      onTap: () {
                        Get.to(DepartmentDetailPage(department: department));
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: ()=> editDepartmentDialog(context, department),
                              icon: const Icon(Icons.edit, size: 25,)
                          ),
                    
                          IconButton(
                              onPressed: ()=> controller.deleteDepartment(department),
                              icon: const Icon(Icons.delete, size: 25,)
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }

  Future addDepartmentDialog(BuildContext context){
    controller.clearFields();
    return Get.defaultDialog(
      title: 'Add Department',
      titleStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
      content: SingleChildScrollView(
        child: Form(
          key: addDeptKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.departmentNameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Department Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter complete information';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.departmentCodeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Department Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter complete information';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.headOfDepartmentController,
                decoration: const InputDecoration(labelText: 'Head of Department'),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter complete information';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.contactPhoneController,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter complete information';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: controller.semesterController,
                decoration: const InputDecoration(labelText: 'Semesters'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter complete information';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'Add',
      confirm: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            fixedSize: MaterialStatePropertyAll(Size(100, 20))
          ),
            onPressed: () {
              if (addDeptKey.currentState!.validate()) {
                controller.addDepartment();
              }
            },
            child: Text('Add', style: Theme.of(context).appBarTheme.titleTextStyle,)
        ),
      ),
    );
  }

  Future editDepartmentDialog(BuildContext context, Department department){
    controller.departmentNameController.text = department.departmentName;
    controller.departmentCodeController.text = department.departmentCode;
    controller.headOfDepartmentController.text = department.headOfDepartment;
    controller.contactPhoneController.text = department.contactPhone;
    controller.semesterController.text = department.totalSemesters.toString();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Department Details'),
          content: Form(
            key: editDeptKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.departmentNameController,
                  decoration: const InputDecoration(labelText: 'Department Name'),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter complete information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.departmentCodeController,
                  decoration: const InputDecoration(labelText: 'Department Code'),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter complete information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.headOfDepartmentController,
                  decoration: const InputDecoration(labelText: 'Head of Department'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter complete information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.contactPhoneController,
                  decoration: const InputDecoration(labelText: 'Contact Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter complete information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.semesterController,
                  decoration: const InputDecoration(labelText: 'Semesters'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter complete information';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (editDeptKey.currentState!.validate()) {
                  var newDepartment = Department(
                    departmentID: department.departmentID,
                    totalSemesters: int.parse(controller.semesterController.text),
                    totalStudents: department.totalStudents,
                    totalTeachers: department.totalTeachers,
                    totalCourses: department.totalCourses,
                    sectionLength: department.sectionLength,
                    departmentName: controller.departmentNameController.text,
                    departmentCode: controller.departmentCodeController.text,
                    headOfDepartment: controller.headOfDepartmentController.text,
                    contactPhone: controller.contactPhoneController.text,
                  );

                  controller.editDepartment(newDepartment);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


}
