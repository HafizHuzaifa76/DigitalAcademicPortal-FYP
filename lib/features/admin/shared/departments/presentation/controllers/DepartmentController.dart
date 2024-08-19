
import '../../domain/entities/Department.dart';
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

class DepartmentController extends GetxController{
  final AddDepartmentUseCase addDepartmentUseCase;
  final DeleteDepartmentUseCase deleteDepartmentUseCase;
  final EditDepartmentUseCase editDepartmentUseCase;
  final AllDepartmentsUseCase allDepartmentsUseCase;

  DepartmentController({required this.addDepartmentUseCase, required this.deleteDepartmentUseCase, required this.editDepartmentUseCase, required this.allDepartmentsUseCase});

  @override
  void onInit() {
    showAllDepartments(); // Fetch the list of departments when the controller is initialized
    super.onInit();
  }

  var totalSemestersController = TextEditingController();
  var totalStudentsController = TextEditingController();
  var totalTeachersController = TextEditingController();
  var departmentNameController = TextEditingController();
  var departmentCodeController = TextEditingController();
  var headOfDepartmentController = TextEditingController();
  var contactPhoneController = TextEditingController();
  var isLoading = false.obs;

  var departmentList = <Department>[].obs;

  Future<void> addDepartment(int departmentID) async {
    var newDepartment = Department(
      departmentID: departmentID,
      totalSemesters: int.parse(totalSemestersController.text),
      totalStudents: int.parse(totalStudentsController.text),
      totalTeachers: int.parse(totalTeachersController.text),
      departmentName: departmentNameController.text,
      departmentCode: departmentCodeController.text,
      headOfDepartment: headOfDepartmentController.text,
      contactPhone: contactPhoneController.text,
    );

    try {
      isLoading(true);
      final result = await addDepartmentUseCase.execute(newDepartment);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Department added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> editDepartment(int departmentID) async {
    var newDepartment = Department(
      departmentID: departmentID,
      totalSemesters: int.parse(totalSemestersController.text),
      totalStudents: int.parse(totalStudentsController.text),
      totalTeachers: int.parse(totalTeachersController.text),
      departmentName: departmentNameController.text,
      departmentCode: departmentCodeController.text,
      headOfDepartment: headOfDepartmentController.text,
      contactPhone: contactPhoneController.text,
    );

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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Department updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteDepartment(Department department) async {

    try {
      isLoading(true);
      final result = await deleteDepartmentUseCase.execute(department);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Department deleted successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );

      }, (departments) {
        departmentList.assignAll(departments);
        print('departments fetched');
      });

      isLoading(false);
  }
}