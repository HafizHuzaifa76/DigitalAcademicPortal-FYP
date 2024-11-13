
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Semester.dart';
import 'package:digital_academic_portal/features/admin/shared/student/domain/usecases/SemesterStudentsUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../domain/usecases/AddStudentUseCase.dart';
import '../../domain/usecases/AllStudentUseCase.dart';
import '../../domain/usecases/DeleteStudentUseCase.dart';
import '../../domain/usecases/DepartmentStudentsUseCase.dart';
import '../../domain/usecases/EditStudentUseCase.dart';
import '../../domain/entities/Student.dart';
import '../../domain/usecases/SetSectionLimitUseCase.dart';

class StudentController extends GetxController {
  final AddStudentUseCase addStudentUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  final EditStudentUseCase editStudentUseCase;
  final AllStudentsUseCase allStudentsUseCase;
  final DepartmentStudentsUseCase departmentStudentsUseCase;
  final SemesterStudentsUseCase semesterStudentsUseCase;
  final SetSectionLimitUseCase setSectionLimitUseCase;

  StudentController({
    required this.addStudentUseCase,
    required this.deleteStudentUseCase,
    required this.editStudentUseCase,
    required this.allStudentsUseCase,
    required this.departmentStudentsUseCase,
    required this.semesterStudentsUseCase,
    required this.setSectionLimitUseCase,
  });

  var studentNameController = TextEditingController();
  var fatherNameController = TextEditingController();
  var studentCNICController = TextEditingController();
  var studentContactNoController = TextEditingController();
  var studentEmailController = TextEditingController();
  var studentAddressController = TextEditingController();
  String selectedYear = '', selectedShift = '', selectedGender = '';

  var isLoading = false.obs;
  var studentList = <Student>[].obs;
  List<Semester> semesterList = [];
  var filteredStudentList = <Student>[].obs;

  void filterStudents(String query) {
    if (query.isEmpty) {
      filteredStudentList.assignAll(studentList);
    } else {
      var lowerCaseQuery = query.toLowerCase();
      var filteredResults = studentList.where((student) {
        return student.studentName.toLowerCase().startsWith(lowerCaseQuery) || student.studentName.toLowerCase().contains(' $lowerCaseQuery') ||
            student.studentRollNo.toLowerCase().startsWith(lowerCaseQuery) || student.studentRollNo.toLowerCase().contains('-$lowerCaseQuery') ||
            student.studentCNIC.toLowerCase().startsWith(lowerCaseQuery) || student.studentSection.toLowerCase().startsWith(lowerCaseQuery) ||
            student.studentEmail.toLowerCase().startsWith(lowerCaseQuery) || student.studentContactNo.toLowerCase().startsWith(lowerCaseQuery) ||
            student.fatherName.toLowerCase().startsWith(lowerCaseQuery) || student.fatherName.toLowerCase().contains(' $lowerCaseQuery');
      }).toList();
      filteredStudentList.assignAll(filteredResults);
    }
  }

  Future<void> showDepartmentStudents(String deptName) async {
    isLoading(true);
    final result = await departmentStudentsUseCase.execute(deptName);

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
      filteredStudentList.assignAll(students); // Show all students initially
    });

    isLoading(false);
  }

  Future<void> showSemesterStudents(String deptName, String semester) async {
    isLoading(true);
    final result = await semesterStudentsUseCase.execute(SemesterParams(deptName, semester));

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
      filteredStudentList.assignAll(students);
      print('Semesters Students fetched');
    });

    isLoading(false);
  }

  Future<void> addStudent(String deptName, String courseCode) async {
    int studentCount = studentList.length + 1;
    String currentRoll = studentCount.toString().padLeft(4, '0');
    String rollNo = '$currentRoll-$courseCode-$selectedYear';

    var newStudent = Student(
      studentRollNo: rollNo,
      studentName: studentNameController.text,
      fatherName: fatherNameController.text,
      studentCNIC: studentCNICController.text,
      studentContactNo: studentContactNoController.text,
      studentEmail: studentEmailController.text,
      studentGender: selectedGender,
      studentAddress: studentAddressController.text,
      studentDepartment: deptName,
      studentShift: selectedShift,
      studentAcademicYear: selectedYear,
      studentSemester: 'SEM-I',
      studentSection: '',
      studentCGPA: 0,
    );

    try {
      isLoading(true);
      EasyLoading.show(status: 'Adding...');
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
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
        );

        clearAllControllers();
        showDepartmentStudents(deptName);

      });

    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> editStudent(Student newStudent) async {

    try {
      isLoading(true);
      EasyLoading.show(status: 'Updating...');
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
        clearAllControllers();
      });

    } finally {
      isLoading(false);
      EasyLoading.dismiss();
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
      filteredStudentList.assignAll(students);
      print('Students fetched');
    });

    isLoading(false);
  }

  void setControllerValues(Student student) {
    studentNameController.text = student.studentName;
    fatherNameController.text = student.fatherName;
    studentCNICController.text = student.studentCNIC;
    studentContactNoController.text = student.studentContactNo;
    studentEmailController.text = student.studentEmail;
    studentAddressController.text = student.studentAddress;
  }

  Future<void> setSectionLimit(String deptName, String semester, int sectionLimit) async {
    try {
      isLoading(true);
      final result = await setSectionLimitUseCase.execute(SectionLimitParams(deptName: deptName, semester: semester, sectionLimit: sectionLimit));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Limit set successfully...\nNow you can add students');

        if(semesterList.isNotEmpty){
          semesterList.first.sectionLimit = sectionLimit;
        }
        Get.back();
      });

    } finally {
      isLoading(false);
      Get.back();
    }
  }



  void clearAllControllers() {
    studentNameController.clear();
    fatherNameController.clear();
    studentCNICController.clear();
    studentContactNoController.clear();
    studentEmailController.clear();
    studentAddressController.clear();
    selectedYear = '';
    selectedShift = '';
    selectedGender = '';
  }
}
