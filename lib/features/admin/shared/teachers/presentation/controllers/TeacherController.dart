
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/AddTeacherUseCase.dart';
import '../../domain/usecases/AllTeacherUseCase.dart';
import '../../domain/usecases/DeleteTeacherUseCase.dart';
import '../../domain/usecases/DeptTeacherUseCase.dart';
import '../../domain/usecases/EditTeacherUseCase.dart';

import '../../domain/entities/Teacher.dart';

class TeacherController extends GetxController{
  final AddTeacherUseCase addTeacherUseCase;
  final DeleteTeacherUseCase deleteTeacherUseCase;
  final EditTeacherUseCase editTeacherUseCase;
  final AllTeachersUseCase allTeachersUseCase;
  final DeptTeachersUseCase deptTeachersUseCase;

  TeacherController({required this.addTeacherUseCase, required this.deleteTeacherUseCase, required this.editTeacherUseCase, required this.allTeachersUseCase, required this.deptTeachersUseCase});

  var teacherNameController = TextEditingController();
  var teacherEmailController = TextEditingController();
  var teacherCNICController = TextEditingController();
  var teacherContactController = TextEditingController();
  var teacherAddressController = TextEditingController();
  var selectedGender = ''.obs;
  var selectedType = ''.obs;

  var isLoading = false.obs;
  var teacherList = <Teacher>[].obs;
  var filteredTeacherList = <Teacher>[].obs;

  void filterTeachers(String query) {
    if (query.isEmpty) {
      filteredTeacherList.assignAll(teacherList);
    } else {
      filteredTeacherList.assignAll(
        teacherList.where((teacher) =>
            teacher.teacherName.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> addTeacher(String deptName) async {

    var newTeacher = Teacher(
      teacherID: DateTime.now().toString(),
      teacherName: teacherNameController.text,
      teacherDept: deptName,
      teacherEmail: teacherEmailController.text,
      teacherCNIC: teacherCNICController.text,
      teacherContact: teacherContactController.text,
      teacherAddress: teacherAddressController.text,
      teacherType: selectedType.value,
      teacherGender: selectedGender.value,
    );

    try {
      isLoading(true);
      final result = await addTeacherUseCase.execute(newTeacher);

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
            'Teacher added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );

        clearAllControllers();
        // Get.to(HomeScreen());
      });

    } finally {
      showAllTeachers();
      isLoading(false);
    }
  }

  Future<void> editTeacher(String teacherID) async {

    var newTeacher = Teacher(
      teacherID: teacherID,
      teacherName: teacherNameController.text,
      teacherDept: 'dept',
      teacherEmail: teacherEmailController.text,
      teacherCNIC: teacherCNICController.text,
      teacherContact: teacherContactController.text,
      teacherAddress: teacherAddressController.text,
      teacherType: selectedType.value,
      teacherGender: selectedGender.value,
    );

    try {
      isLoading(true);
      final result = await editTeacherUseCase.execute(newTeacher);

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
            'Teacher updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );

        clearAllControllers();
        // Get.to(HomeScreen());
      });

    } finally {
      showAllTeachers();
      isLoading(false);
    }
  }

  Future<void> deleteTeacher(Teacher teacher) async {

    try {
      isLoading(true);
      final result = await deleteTeacherUseCase.execute(teacher);

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
            'Teacher deleted successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      showAllTeachers();
      isLoading(false);
    }
  }

  Future<void> showAllTeachers() async {
      isLoading(true);
      final result = await allTeachersUseCase.execute(null);

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

      }, (teacher) {
        teacherList.assignAll(teacher);
        filteredTeacherList.assignAll(teacher);
        print('Teachers fetched');
      });

      isLoading(false);
  }

  Future<void> showDeptTeachers(String deptName) async {
      isLoading(true);
      final result = await deptTeachersUseCase.execute(deptName);

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

      }, (teacher) {
        teacherList.assignAll(teacher);
        filteredTeacherList.assignAll(teacher);
        print('Teachers fetched');
      });

      isLoading(false);
  }

  void clearAllControllers() {
    teacherNameController.clear();
    teacherEmailController.clear();
    teacherCNICController.clear();
    teacherContactController.clear();
    teacherAddressController.clear();
    selectedGender.value = '';
    selectedType.value = '';
  }
}