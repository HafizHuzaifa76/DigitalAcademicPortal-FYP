import 'package:digital_academic_portal/features/administrator_panel/shared/departments/presentation/pages/DepartmentDetailPage.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => addDepartmentBottomSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 80),
              centerTitle: true,
              title: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Departments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 55,
                      child: TextField(
                        onChanged: (query) {
                          controller.filterDepartments(query); // Add filtering logic
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: 'Search Departments...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/department_icon.png', height: 40, width: 40,),
              ),
            ],
          ),

          // Main content list of Departments
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation4.json',
                    width: 120,
                    height: 120,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              );
            } else {
              if (controller.filteredDepartmentList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No departments available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      final department = controller.filteredDepartmentList[index]; // Filtered list of departments
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          child: ListTile(
                            title: Text(
                              department.departmentName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            subtitle: Text(
                                'Code: ${department.departmentCode} \nHOD: ${department.headOfDepartment}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => editDepartmentBottomSheet(context, department),
                                  icon: const Icon(Icons.edit, size: 25),
                                ),
                                IconButton(
                                  onPressed: () => controller.deleteDepartment(department),
                                  icon: const Icon(Icons.delete, size: 25),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(DepartmentDetailPage(department: department));
                            },
                          ),
                        ),
                      );
                    },
                    childCount: controller.filteredDepartmentList.length, // Use filtered list
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Future addDepartmentBottomSheet(BuildContext context) {
    controller.clearFields(); // Clear fields when the bottom sheet opens
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-height bottom sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Handles soft keyboard
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Department',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: Form(
                  key: addDeptKey, // Assuming you have defined a GlobalKey<FormState>
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller.departmentNameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Department Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.departmentCodeController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Department Code',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.headOfDepartmentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Head of Department',
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.contactPhoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Contact Phone',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.semesterController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Semesters',
                        ),
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
              const SizedBox(height: 20),
              // Add button
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 45)),
                ),
                onPressed: () {
                  if (addDeptKey.currentState!.validate()) {
                    controller.addDepartment(); // Call your addDepartment method
                    Get.back(); // Closes the bottom sheet after saving
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future editDepartmentBottomSheet(BuildContext context, Department department) {
    controller.updateDepartmentDetails(department); // Populate the fields with existing department data

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-height bottom sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Handles soft keyboard
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Department Details',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: Form(
                  key: editDeptKey, // Assuming you have defined a GlobalKey<FormState>
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller.departmentNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Department Name',
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.departmentCodeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Department Code',
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.headOfDepartmentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Head of Department',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter complete information';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.contactPhoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Contact Phone',
                        ),
                        keyboardType: TextInputType.phone,
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
              const SizedBox(height: 20),
              // Save button
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 45)),
                ),
                onPressed: () {
                  if (editDeptKey.currentState!.validate()) {
                    var newDepartment = Department(
                      departmentID: department.departmentID,
                      totalSemesters: department.totalSemesters,
                      totalStudents: department.totalStudents,
                      totalTeachers: department.totalTeachers,
                      totalCourses: department.totalCourses,
                      sectionLength: department.sectionLength,
                      departmentName: controller.departmentNameController.text,
                      departmentCode: controller.departmentCodeController.text,
                      headOfDepartment: controller.headOfDepartmentController.text,
                      contactPhone: controller.contactPhoneController.text,
                    );

                    controller.editDepartment(newDepartment); // Call your editDepartment method
                    Get.back(); // Closes the bottom sheet after saving
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

}
