
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import '../../domain/usecases/AddStudentUseCase.dart';
import '../../domain/usecases/AllStudentUseCase.dart';
import '../../domain/usecases/DeleteStudentUseCase.dart';
import '../../domain/usecases/EditStudentUseCase.dart';

import '../../domain/entities/Student.dart';

class StudentController extends GetxController{
  final AddStudentUseCase addStudentUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  final EditStudentUseCase editStudentUseCase;
  final AllStudentsUseCase allStudentsUseCase;

  StudentController({required this.addStudentUseCase, required this.deleteStudentUseCase, required this.editStudentUseCase, required this.allStudentsUseCase});

  @override
  void onInit() {
    showAllStudents(); // Fetch the list of Students when the controller is initialized
    super.onInit();
  }

  var studentNameController = TextEditingController();
  var fatherNameController = TextEditingController();
  var studentCNICController = TextEditingController();
  var studentContactNoController = TextEditingController();
  var studentEmailController = TextEditingController();
  var studentGenderController = TextEditingController();
  var studentAddressController = TextEditingController();
  var studentDepartmentController = TextEditingController();
  var studentSemesterController = TextEditingController();
  var studentSectionController = TextEditingController();
  var studentCGPAController = TextEditingController();

  var isLoading = false.obs;

  var studentList = <Student>[].obs;

  Future<void> addStudent(String studentID) async {
    var newStudent = Student(
      studentID: studentID,
      studentName: studentNameController.text,
      fatherName: fatherNameController.text,
      studentCNIC: studentCNICController.text,
      studentContactNo: studentContactNoController.text,
      studentEmail: studentEmailController.text,
      studentGender: studentGenderController.text,
      studentAddress: studentAddressController.text,
      studentDepartment: studentDepartmentController.text,
      studentSemester: studentSemesterController.text,
      studentSection: studentSectionController.text,
      studentCGPA: studentCGPAController.text,
    );

    try {
      isLoading(true);
      final result = await addStudentUseCase.execute(newStudent);

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
            'Student added successfully...',
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

  Future<void> editStudent(String studentID) async {
    var newStudent = Student(
      studentID: studentID,
      studentName: studentNameController.text,
      fatherName: fatherNameController.text,
      studentCNIC: studentCNICController.text,
      studentContactNo: studentContactNoController.text,
      studentEmail: studentEmailController.text,
      studentGender: studentGenderController.text,
      studentAddress: studentAddressController.text,
      studentDepartment: studentDepartmentController.text,
      studentSemester: studentSemesterController.text,
      studentSection: studentSectionController.text,
      studentCGPA: studentCGPAController.text,
    );

    try {
      isLoading(true);
      final result = await editStudentUseCase.execute(newStudent);

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
            'Student updated successfully...',
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

  Future<void> deleteStudent(Student student) async {

    try {
      isLoading(true);
      final result = await deleteStudentUseCase.execute(student);

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
            'Student deleted successfully...',
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

  Future<void> showAllStudents() async {
      isLoading(true);
      final result = await allStudentsUseCase.execute(null);

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

      }, (students) {
        studentList.assignAll(students);
        print('Students fetched');
      });

      isLoading(false);
  }
}