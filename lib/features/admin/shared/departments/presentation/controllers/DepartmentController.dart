
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/domain/usecases/AllSemestersUseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/presentation/pages/DepartmentDetailPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../data/models/DepartmentModel.dart';
import '../../domain/entities/Department.dart';
import '../../domain/entities/Semester.dart';
import '../../domain/usecases/AddDepartmentUseCase.dart';
import '../../domain/usecases/AllDepartmentsUseCase.dart';
import '../../domain/usecases/DeleteDepartmentUseCase.dart';
import '../../domain/usecases/EditDepartmentUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

class DepartmentController extends GetxController {
  final AddDepartmentUseCase addDepartmentUseCase;
  final DeleteDepartmentUseCase deleteDepartmentUseCase;
  final EditDepartmentUseCase editDepartmentUseCase;
  final AllDepartmentsUseCase allDepartmentsUseCase;
  final AllSemestersUseCase allSemestersUseCase;

  DepartmentController({required this.addDepartmentUseCase, required this.deleteDepartmentUseCase, required this.editDepartmentUseCase, required this.allDepartmentsUseCase, required this.allSemestersUseCase});

  @override
  void onInit() {
    showAllDepartments(); // Fetch the list of departments when the controller is initialized

    super.onInit();
  }

  var departmentNameController = TextEditingController();
  var departmentCodeController = TextEditingController();
  var headOfDepartmentController = TextEditingController();
  var contactPhoneController = TextEditingController();
  var semesterController = TextEditingController();
  var isLoading = false.obs;

  var departmentList = <Department>[].obs;
  var filteredDepartmentList = <Department>[].obs;
  var semestersList = <Semester>[].obs;

  void filterDepartments(String query) {
    if (query.isEmpty) {
      filteredDepartmentList.assignAll(departmentList); // Reset to full list if no query
    } else {
      filteredDepartmentList.assignAll(
        departmentList.where((department) =>
            department.departmentName.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> addDepartment() async {
    EasyLoading.show(status: 'Adding...');

    var newDepartment = Department(
      departmentID: departmentList.length,
      totalSemesters: int.parse(semesterController.text),
      totalStudents: 0,
      totalTeachers: 0,
      totalCourses: 0,
      sectionLength: 0,
      departmentName: departmentNameController.text.trim(),
      departmentCode: departmentCodeController.text.trim(),
      headOfDepartment: headOfDepartmentController.text.trim(),
      contactPhone: contactPhoneController.text.trim(),
    );

    final result = await addDepartmentUseCase.execute(newDepartment);

    try {
      isLoading(true);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (department) {
        Get.snackbar(
            'Success',
            'Department added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        Get.off(DepartmentDetailPage(department: department));
      });

    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
      Get.back();
    }
  }

  // Clear the controllers after saving
  void clearFields() {
    departmentNameController.clear();
    departmentCodeController.clear();
    headOfDepartmentController.clear();
    contactPhoneController.clear();
    semesterController.clear();
  }

  void updateDepartmentDetails(Department department) {
    departmentNameController.text = department.departmentName;
    departmentCodeController.text = department.departmentCode;
    headOfDepartmentController.text = department.headOfDepartment;
    contactPhoneController.text = department.contactPhone;
    semesterController.text = department.totalSemesters.toString();
  }

  Future<void> editDepartment(Department newDepartment) async {
    try {
      isLoading(true);
      final result = await editDepartmentUseCase.execute(newDepartment);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Department updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteDepartment(Department department) async {

    try {
      isLoading(true);
      EasyLoading.show(status: 'Deleting');
      final result = await deleteDepartmentUseCase.execute(department);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Department deleted successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        Get.offAndToNamed('departments');
      });

    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future<void> showAllDepartments() async {
      isLoading(true);
      final result = await allDepartmentsUseCase.execute(null);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );

      }, (departments) {
        departmentList.assignAll(departments);
        filteredDepartmentList.assignAll(departments);
        print('departments fetched');
      });

      isLoading(false);
  }

  Future<void> showAllSemesters(String deptName) async {
      final result = await allSemestersUseCase.execute(deptName);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
        if (kDebugMode) {
          print(message);
        }
      }, (semesters) {
        semestersList.assignAll(semesters);
        print('semesters fetched');
      });

  }
}
