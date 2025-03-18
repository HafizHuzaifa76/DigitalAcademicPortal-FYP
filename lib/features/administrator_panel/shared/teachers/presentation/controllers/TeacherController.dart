
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/Utils.dart';
import '../../domain/usecases/AddTeacherUseCase.dart';
import '../../domain/usecases/AllTeacherUseCase.dart';
import '../../domain/usecases/DeleteTeacherUseCase.dart';
import '../../domain/usecases/DeptTeacherUseCase.dart';
import '../../domain/usecases/EditTeacherUseCase.dart';

import '../../domain/entities/Teacher.dart';

class TeacherController extends GetxController{
  final AddTeacherUseCase addTeacherUseCase;
  final AddTeacherListUseCase addTeacherListUseCase;
  final DeleteTeacherUseCase deleteTeacherUseCase;
  final EditTeacherUseCase editTeacherUseCase;
  final AllTeachersUseCase allTeachersUseCase;
  final DeptTeachersUseCase deptTeachersUseCase;

  TeacherController({required this.addTeacherUseCase, required this.addTeacherListUseCase, required this.deleteTeacherUseCase, required this.editTeacherUseCase, required this.allTeachersUseCase, required this.deptTeachersUseCase});

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
        Utils().showSuccessSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
            'Success',
            'Teacher added successfully...',
        );

        clearAllControllers();
        // Get.to(HomeScreen());
      });

    } finally {
      showAllTeachers();
      isLoading(false);
    }
  }

  Future<void> addTeacherList(List<Teacher> teacherList) async {

    try {
      isLoading(true);
      EasyLoading.show(status: 'Adding Teachers...');
      final result = await addTeacherListUseCase.execute(teacherList);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showSuccessSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar('Success', right);
        // Get.to(HomeScreen());
      });

    } finally {
      showDeptTeachers(teacherList.first.teacherDept);
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future<void> editTeacher(String teacherID) async {

    var newTeacher = Teacher(
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
        Utils().showSuccessSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
            'Success',
            'Teacher updated successfully...',
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
        Utils().showSuccessSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
            'Success',
            'Teacher deleted successfully...',
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
        Utils().showSuccessSnackBar('Error', message);

      }, (teacher) {
        teacherList.assignAll(teacher);
        filteredTeacherList.assignAll(teacher);
        debugPrint('Teachers fetched');
      });

      isLoading(false);
  }

  Future<void> showDeptTeachers(String deptName) async {
      isLoading(true);
      final result = await deptTeachersUseCase.execute(deptName);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showSuccessSnackBar('Error', message);

      }, (teacher) {
        teacherList.assignAll(teacher);
        filteredTeacherList.assignAll(teacher);
        debugPrint('Teachers fetched');
      });

      isLoading(false);
  }
  Future<List<Teacher>> fetchTeachersFromExcel(String deptName) async {
    try {
      // Open file picker to select an Excel file
      debugPrint('Pick file for teachers');
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

      List<Teacher> teachers = [];

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
        "Teacher Name",
        "Email",
        "CNIC",
        "Contact No",
        "Address",
        "Type",
        "Gender",
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

        teachers.add(Teacher(
          teacherName: row[headerIndexMap["Teacher Name"]!]?.value.toString() ?? "",
          teacherDept: deptName,
          teacherEmail: row[headerIndexMap["Email"]!]?.value.toString() ?? "",
          teacherCNIC: row[headerIndexMap["CNIC"]!]?.value.toString() ?? "",
          teacherContact: row[headerIndexMap["Contact No"]!]?.value.toString() ?? "",
          teacherAddress: row[headerIndexMap["Address"]!]?.value.toString() ?? "",
          teacherType: row[headerIndexMap["Type"]!]?.value.toString() ?? "",
          teacherGender: row[headerIndexMap["Gender"]!]?.value.toString() ?? "",
        ));
      }

      return teachers;
    } catch (e) {
      Utils().showErrorSnackBar('Error reading Excel file', '$e');
      return [];
    }
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