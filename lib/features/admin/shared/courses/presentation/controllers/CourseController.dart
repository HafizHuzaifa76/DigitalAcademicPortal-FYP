
import 'dart:io';

import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/usecases/SemesterCoursesUseCase.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/Utils.dart';
import '../../../departments/domain/entities/Semester.dart';
import '../../domain/usecases/AddCourseUseCase.dart';
import '../../domain/usecases/AllCourseUseCase.dart';
import '../../domain/usecases/DeleteCourseUseCase.dart';
import '../../domain/usecases/DeptCoursesUseCase.dart';
import '../../domain/usecases/EditCourseUseCase.dart';
import '../../domain/entities/SemesterCourse.dart';
import '../../domain/usecases/UpdateCourseInSemesterUseCase.dart';

class CourseController extends GetxController{
  final AddCourseUseCase addCourseUseCase;
  final AddCourseListUseCase addCourseListUseCase;
  final AddSemesterCoursesUseCase addSemesterCoursesUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;
  final EditCourseUseCase editCourseUseCase;
  final DeptCoursesUseCase deptCoursesUseCase;
  final SemesterCoursesUseCase semesterCoursesUseCase;
  final AllSemesterCoursesUseCase allSemesterCoursesUseCase;
  final UpdateCourseInSemesterUseCase updateCourseInSemesterUseCase;

  CourseController({required this.addCourseUseCase, required this.deleteCourseUseCase, required this.editCourseUseCase, required this.addCourseListUseCase, required this.deptCoursesUseCase, required this.semesterCoursesUseCase, required this.addSemesterCoursesUseCase, required this.allSemesterCoursesUseCase, required this.updateCourseInSemesterUseCase});

  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseNameController = TextEditingController();
  var isLoading = false.obs;

  var semesterCourseList = <SemesterCourse>[].obs;
  var allCoursesList = <DepartmentCourse>[].obs;
  var filteredAllCourseList = <DepartmentCourse>[].obs;
  var filteredSemesterCourseList = <SemesterCourse>[].obs;
  var selectedTotalCourses = 5.obs;
  var selectedElectiveCourses = 0.obs;
  List<Semester> semesterList = [];
  var titlePadding = 70.0.obs;
  var selectedTab = 0.obs;

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  void updatePadding(double offset) {
    titlePadding.value = offset > 100 ? 15 : offset >  60 ? 30 : 70.0;
  }

  void updateTotalCourses(int value) {
    selectedTotalCourses.value = value + 1;
    // Ensure elective courses don't exceed total courses
    if (selectedElectiveCourses.value > selectedTotalCourses.value) {
      selectedElectiveCourses.value = selectedTotalCourses.value;
    }
  }

  void updateElectiveCourses(int value) {
    selectedElectiveCourses.value = value;
  }

  void filterCourses(String query) {
    if (query.isEmpty) {
      filteredSemesterCourseList.assignAll(semesterCourseList);
      filteredAllCourseList.assignAll(allCoursesList);
    } else {
      var lowerCaseQuery = query.toLowerCase();
      var semesterCoursesFilteredResults = semesterCourseList.where((course) {
        return course.courseName.toLowerCase().startsWith(lowerCaseQuery) || course.courseName.toLowerCase().contains(' $lowerCaseQuery') ||
            course.courseCode.toLowerCase().startsWith(lowerCaseQuery) || course.courseCode.toLowerCase().contains('-$lowerCaseQuery');
      }).toList();

      var allCoursesFilteredResults = allCoursesList.where((course) {
        return course.courseName.toLowerCase().startsWith(lowerCaseQuery) || course.courseName.toLowerCase().contains(' $lowerCaseQuery') ||
            course.courseCode.toLowerCase().startsWith(lowerCaseQuery) || course.courseCode.toLowerCase().contains('-$lowerCaseQuery');
      }).toList();

      filteredSemesterCourseList.assignAll(semesterCoursesFilteredResults);
      filteredAllCourseList.assignAll(allCoursesFilteredResults);
      print(' list1: ${filteredSemesterCourseList.length}');
      print(' list2: ${filteredAllCourseList.length}');
    }
  }

  Future<void> addCourse(DepartmentCourse newCourse) async {
    try {
      EasyLoading.show(status: 'Adding...');
      final result = await addCourseUseCase.execute(CourseParams(newCourse.courseDept, newCourse));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Course added successfully...');

        clearTextControllers();
      });

    } finally {
      EasyLoading.dismiss();
      showDeptCourses(newCourse.courseDept).then((_) => isLoading(false));
    }
  }

  Future<void> addCourseList(List<DepartmentCourse> courses) async {
    try {
      EasyLoading.show(status: 'Adding...');
      final result = await addCourseListUseCase.execute(courses);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Course added successfully...');
      });

    } finally {
      EasyLoading.dismiss();
      showDeptCourses(courses.first.courseDept).then((_) => isLoading(false));
    }
  }

  Future<void> addSemesterCourseList(List<SemesterCourse> courses) async {
    try {
      EasyLoading.show(status: 'Adding...');
      final result = await addSemesterCoursesUseCase.execute(courses);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Course added successfully...');
        var sem = semesterList.firstWhere((index) => index.semesterName == courses.first.courseSemester);
        sem.addMultipleCourses(courses.length);
        showAllSemesterCourses(courses.first.courseDept);
      });

    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> editCourse(SemesterCourse newCourse) async {

    try {
      EasyLoading.show(status: 'Updating...');
      final result = await editCourseUseCase.execute(CourseParams(newCourse.courseDept, newCourse));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Course updated successfully...');
        clearTextControllers();
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteCourse(String deptName, SemesterCourse course) async {

    try {
      EasyLoading.show(status: 'Deleting...');
      final result = await deleteCourseUseCase.execute(CourseParams(deptName, course));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Course deleted successfully...');
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> showSemesterCourses(String deptName, String semester) async {
      isLoading(true);
      final result = await semesterCoursesUseCase.execute(SemesterParams(deptName, semester));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (courses) {
        semesterCourseList.assignAll(courses);
        filteredSemesterCourseList.assignAll(semesterCourseList);
        print('Semester Courses fetched');
      });

      isLoading(false);
  }

  Future<void> showDeptCourses(String deptName) async {
      isLoading(true);
      final result = await deptCoursesUseCase.execute(deptName);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (courses) {
        allCoursesList.assignAll(courses);
        filteredAllCourseList.assignAll(allCoursesList);
        print('Courses fetched');
      });

  }

  Future<void> showAllSemesterCourses(String deptName) async {
      isLoading(true);
      final result = await allSemesterCoursesUseCase.execute(deptName);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (courses) {
        semesterCourseList.assignAll(courses);
        filteredSemesterCourseList.assignAll(semesterCourseList);
        print('Courses fetched');
      });

      isLoading(false);
  }

  Future<void> updateSemester(String deptName, int index, Semester semester) async {

    try {
      EasyLoading.show(status: 'Updating New Information...');
      final result = await updateCourseInSemesterUseCase.execute(UpdateSemesterParams(deptName, semester));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar('Success', 'Now you can add courses in ${semester.semesterName}');

        if(index != -1){
          semesterList[index] = semester;
        }
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<List<DepartmentCourse>> fetchCoursesFromExcel(String deptName) async {
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

      List<DepartmentCourse> courses = [];

      // Get the headers (assuming the first row contains the headers)
      final headers = sheet.rows.first;
      Map<String, int> headerIndexMap = {};

      // Map headers to their column indices
        print('headerValue');
      for (int i = 0; i < headers.length; i++) {
        final headerValue = headers[i]?.value?.toString() ?? '';
        print(headerValue);
        headerIndexMap[headerValue.trim()] = i;
      }

      // Expected headers
      const requiredHeaders = [
        "Course Title",
        "Course Code",
        "Credit Hours",
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

        if (row[headerIndexMap["Course Title"]!]?.value != null) {
          courses.add(
            DepartmentCourse(
                courseName: row[headerIndexMap["Course Title"]!]?.value.toString() ?? "",
                courseCode: row[headerIndexMap["Course Code"]!]?.value.toString() ?? "",
                courseDept: deptName,
                courseCreditHours: int.parse(row[headerIndexMap["Credit Hours"]!]?.value.toString() ?? '0')
            )
          );
        }
      }

      return courses;
    } catch (e) {
      Utils().showErrorSnackBar('Error reading Excel file', '$e');
      print(e);
      return [];
    }
  }

  void clearTextControllers() {
    courseCodeController.clear();
    courseNameController.clear();
  }
}