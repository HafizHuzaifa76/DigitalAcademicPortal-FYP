
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/AddTeacherUseCase.dart';
import '../../domain/usecases/AllTeacherUseCase.dart';
import '../../domain/usecases/DeleteTeacherUseCase.dart';
import '../../domain/usecases/EditTeacherUseCase.dart';

import '../../domain/entities/Teacher.dart';

class TeacherController extends GetxController{
  final AddTeacherUseCase addTeacherUseCase;
  final DeleteTeacherUseCase deleteTeacherUseCase;
  final EditTeacherUseCase editTeacherUseCase;
  final AllTeachersUseCase allTeachersUseCase;

  TeacherController({required this.addTeacherUseCase, required this.deleteTeacherUseCase, required this.editTeacherUseCase, required this.allTeachersUseCase});

  @override
  void onInit() {
    showAllTeachers(); // Fetch the list of Teachers when the controller is initialized
    super.onInit();
  }

  var teacherNameController = TextEditingController();
  var teacherDeptController = TextEditingController();
  var teacherEmailController = TextEditingController();
  var teacherCNICController = TextEditingController();
  var teacherContactController = TextEditingController();
  var teacherAddressController = TextEditingController();
  var teacherTypeController = TextEditingController();
  var teacherGenderController = TextEditingController();
  var isLoading = false.obs;

  var teacherList = <Teacher>[].obs;

  Future<void> addTeacher(String teacherID) async {

    // Create a Teacher using the controllers
    var newTeacher = Teacher(
      teacherID: teacherID,
      teacherName: teacherNameController.text,
      teacherDept: teacherDeptController.text,
      teacherEmail: teacherEmailController.text,
      teacherCNIC: teacherCNICController.text,
      teacherContact: teacherContactController.text,
      teacherAddress: teacherAddressController.text,
      teacherType: teacherTypeController.text,
      teacherGender: teacherGenderController.text,
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
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> editTeacher(String teacherID) async {

    var newTeacher = Teacher(
      teacherID: teacherID,
      teacherName: teacherNameController.text,
      teacherDept: teacherDeptController.text,
      teacherEmail: teacherEmailController.text,
      teacherCNIC: teacherCNICController.text,
      teacherContact: teacherContactController.text,
      teacherAddress: teacherAddressController.text,
      teacherType: teacherTypeController.text,
      teacherGender: teacherGenderController.text,
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
        // Get.to(HomeScreen());
      });

    } finally {
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
        print('Teachers fetched');
      });

      isLoading(false);
  }
}