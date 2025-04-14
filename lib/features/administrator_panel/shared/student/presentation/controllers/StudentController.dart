
import 'dart:io';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/AddStudentListUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/SemesterStudentsUseCase.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final AddStudentListUseCase addStudentListUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  final EditStudentUseCase editStudentUseCase;
  final AllStudentsUseCase allStudentsUseCase;
  final DepartmentStudentsUseCase departmentStudentsUseCase;
  final SemesterStudentsUseCase semesterStudentsUseCase;
  final SetSectionLimitUseCase setSectionLimitUseCase;

  StudentController({
    required this.addStudentUseCase,
    required this.addStudentListUseCase,
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

  final ScrollController scrollController = ScrollController();
  RxDouble titlePadding = 70.0.obs;

  var isLoading = false.obs;
  var studentList = <Student>[].obs;
  var departmentWiseStudents = <String, List<Student>>{}.obs;
  List<Semester> semesterList = [];
  var filteredStudentList = <Student>[].obs;
  String deptName = 'department';

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_adjustTitlePadding);
  }

  @override
  void onClose() {
    scrollController.removeListener(_adjustTitlePadding);
    scrollController.dispose();
    super.onClose();
  }

  void _adjustTitlePadding() {
    if (scrollController.offset > 50) {
      titlePadding.value = 20.0;
    } else {
      titlePadding.value = 70.0;
    }
  }

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

  Future<void> showDepartmentStudents() async {
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
      print('Department Students fetched ${students.length}');
    });

    isLoading(false);
  }

  Future<void> showSemesterStudents(String semester) async {
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

  Future<void> addStudent(String courseCode) async {
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
        showDepartmentStudents();

      });

    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> addNewStudentList(String courseCode) async {
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
        showDepartmentStudents();

      });

    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> addStudentList(List<Student> studentsList, bool isNewStudent) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'Adding Students\nIt take some time\nPlease wait...');

      final result = await addStudentListUseCase.execute(StudentListParams(studentsList, isNewStudent));

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
            'Students added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
        );

        clearAllControllers();
        showDepartmentStudents();
        Get.back();

      });

    } finally {
      isLoading(false);
      EasyLoading.dismiss();
      Get.back();
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
      departmentWiseStudents.value = students;
      filteredStudentList.assignAll(students.values.expand((list) => list));
      print('All Students fetched ${students.length}');
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

  Future<void> setSectionLimit(String semester, int sectionLimit) async {
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

  Future<List<Student>> fetchPreviousStudentsFromExcel(String semester) async {
    try {
      // Open file picker to select an Excel file
      print('pick file');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null) {
        throw Exception("No file selected");
      }

      File file = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      Sheet? sheet = excel.sheets.values.first;

      if (sheet == null) {
        throw Exception("No sheets found in Excel file");
      }

      List<Student> students = [];

      // Get the headers (assuming the first row contains the headers)
      final headers = sheet.rows.first;
      Map<String, int> headerIndexMap = {};

      // Map headers to their column indices
      for (int i = 0; i < headers.length; i++) {
        final headerValue = headers[i]?.value?.toString() ?? '';
        headerIndexMap[headerValue.trim()] = i;
      }

      // Expected headers
      const requiredHeaders = [
        "Roll No",
        "Name",
        "Father Name",
        "CNIC",
        "Contact No",
        "Email",
        "Gender",
        "Address",
        "Shift",
        "Section",
        "CGPA",
      ];

      // Ensure all required headers are present
      for (var header in requiredHeaders) {
        if (!headerIndexMap.containsKey(header)) {
          throw Exception("Missing required header: $header");
        }
      }

      // Iterate through rows (skip header row)
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];

        var rollNo = row[headerIndexMap["Roll No"]!]?.value.toString() ?? "";
        var year = rollNo.split('-').last;
        students.add(Student(
          studentRollNo: rollNo,
          studentName: row[headerIndexMap["Name"]!]?.value.toString() ?? "",
          fatherName: row[headerIndexMap["Father Name"]!]?.value.toString() ?? "",
          studentCNIC: row[headerIndexMap["CNIC"]!]?.value.toString() ?? "",
          studentContactNo: row[headerIndexMap["Contact No"]!]?.value.toString() ?? "",
          studentEmail: row[headerIndexMap["Email"]!]?.value.toString() ?? "",
          studentGender: row[headerIndexMap["Gender"]!]?.value.toString() ?? "",
          studentAddress: row[headerIndexMap["Address"]!]?.value.toString() ?? "",
          studentDepartment: deptName,
          studentSemester: semester,
          studentShift: row[headerIndexMap["Shift"]!]?.value.toString() ?? "",
          studentAcademicYear: '$year - ${int.parse(year) + 4}',
          studentSection: row[headerIndexMap["Section"]!]?.value.toString() ?? "",
          studentCGPA: double.tryParse(row[headerIndexMap["CGPA"]!]?.value.toString() ?? "0") ?? 0.0,
        ));
      }

      return students;
    } catch (e) {
      Utils().showErrorSnackBar('Error reading Excel file', '$e');
      return [];
    }
  }

  Future<List<Student>> fetchNewStudentsFromExcel(String courseCode) async {
    try {
      // Open file picker to select an Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null) {
        throw Exception("No file selected");
      }

      File file = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      Sheet? sheet = excel.sheets.values.first;

      List<Student> students = [];

      // Get the headers (assuming the first row contains the headers)
      final headers = sheet.rows.first;
      Map<String, int> headerIndexMap = {};

      // Map headers to their column indices
      for (int i = 0; i < headers.length; i++) {
        final headerValue = headers[i]?.value?.toString() ?? '';
        headerIndexMap[headerValue.trim()] = i;
      }

      // Expected headers
      const requiredHeaders = [
        "Name",
        "Father Name",
        "CNIC",
        "Contact No",
        "Email",
        "Gender",
        "Address",
        "Shift",
      ];

      // Ensure all required headers are present
      for (var header in requiredHeaders) {
        if (!headerIndexMap.containsKey(header)) {
          throw Exception("Missing required header: $header");
        }
      }

      int morningIndex = 1, eveningIndex = 201;
      List<Student> morningStudentsList = studentList.where((student) => student.studentShift.toLowerCase() == 'morning').toList();
      List<Student> eveningStudentsList = studentList.where((student) => student.studentShift.toLowerCase() == 'evening').toList();

      // Iterate through rows (skip header row)
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];

        String currentRoll;
        row[headerIndexMap["Shift"]!]?.value.toString().toLowerCase() == 'morning' ? {
          currentRoll = (morningStudentsList.length + morningIndex).toString().padLeft(4, '0'),
          morningIndex++
        } : {
          currentRoll = (eveningStudentsList.length + eveningIndex).toString().padLeft(4, '0'),
          eveningIndex++
        };

        String rollNo = '$currentRoll-$courseCode-${DateTime.now().year}';
        if (kDebugMode) {
          print(rollNo);
        }

        students.add(Student(
          studentRollNo: rollNo,
          studentName: row[headerIndexMap["Name"]!]?.value.toString() ?? "",
          fatherName: row[headerIndexMap["Father Name"]!]?.value.toString() ?? "",
          studentCNIC: row[headerIndexMap["CNIC"]!]?.value.toString() ?? "",
          studentContactNo: row[headerIndexMap["Contact No"]!]?.value.toString() ?? "",
          studentEmail: row[headerIndexMap["Email"]!]?.value.toString() ?? "",
          studentGender: row[headerIndexMap["Gender"]!]?.value.toString() ?? "",
          studentAddress: row[headerIndexMap["Address"]!]?.value.toString() ?? "",
          studentShift: row[headerIndexMap["Shift"]!]?.value.toString() ?? "",
          studentDepartment: deptName,
          studentSemester: 'SEM-I',
          studentAcademicYear: "${DateTime.now().year} - ${DateTime.now().year + 4}",
          studentSection: "",
          studentCGPA: 0.0,
        ));
      }

      return students;
    } catch (e) {
      Utils().showErrorSnackBar('Error reading Excel file', '$e');
      return [];
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
