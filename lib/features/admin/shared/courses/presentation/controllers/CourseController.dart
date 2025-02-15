
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
  final DeleteCourseUseCase deleteCourseUseCase;
  final EditCourseUseCase editCourseUseCase;
  final AllCoursesUseCase allCoursesUseCase;
  final DeptCoursesUseCase deptCoursesUseCase;
  final SemesterCoursesUseCase semesterCoursesUseCase;
  final UpdateCourseInSemesterUseCase updateCourseInSemesterUseCase;

  CourseController({required this.addCourseUseCase, required this.deleteCourseUseCase, required this.editCourseUseCase, required this.allCoursesUseCase, required this.addCourseListUseCase, required this.deptCoursesUseCase, required this.semesterCoursesUseCase, required this.updateCourseInSemesterUseCase});

  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseNameController = TextEditingController();
  var isLoading = false.obs;

  var courseList = <SemesterCourse>[].obs;
  var allCoursesList = <DepartmentCourse>[].obs;
  var filteredCourseList = <SemesterCourse>[].obs;
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
      filteredCourseList.assignAll(courseList);
    } else {
      var lowerCaseQuery = query.toLowerCase();
      var filteredResults = courseList.where((course) {
        return course.courseName.toLowerCase().startsWith(lowerCaseQuery) || course.courseName.toLowerCase().contains(' $lowerCaseQuery') ||
            course.courseCode.toLowerCase().startsWith(lowerCaseQuery) || course.courseCode.toLowerCase().contains('-$lowerCaseQuery');
      }).toList();
      filteredCourseList.assignAll(filteredResults);
      print(' list: ${filteredCourseList.length}');
    }
  }

  Future<void> addCourse(DepartmentCourse newCourse) async {
    try {
      EasyLoading.show(status: 'Adding...');
      final result = await addCourseUseCase.execute(CourseParams(newCourse.courseDept, newCourse));

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
            'Course added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
        );

        clearTextControllers();
      });

    } finally {
      EasyLoading.dismiss();
      showDeptCourses(newCourse.courseDept);
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
      showDeptCourses(courses.first.courseDept);
    }
  }

  Future<void> editCourse(SemesterCourse newCourse) async {

    try {
      EasyLoading.show(status: 'Updating...');
      final result = await editCourseUseCase.execute(CourseParams(newCourse.courseDept, newCourse));

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
            'Course updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );

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
            'Course deleted successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
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
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );

      }, (courses) {
        courseList.assignAll(courses);
        filteredCourseList.assignAll(courseList);
        print('Semester Courses fetched');
      });

      isLoading(false);
  }

  Future<void> showDeptCourses(String deptName) async {
      isLoading(true);
      final result = await deptCoursesUseCase.execute(deptName);

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

      }, (courses) {
        allCoursesList.assignAll(courses);
        filteredCourseList.assignAll(courseList);
        print('Courses fetched');
      });

      isLoading(false);
  }

  Future<void> showAllCourses() async {
      isLoading(true);
      final result = await allCoursesUseCase.execute(null);

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

      }, (courses) {
        courseList.assignAll(courses);
        filteredCourseList.assignAll(courseList);
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
            'Now you can add courses in ${semester.semesterName}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
        );

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
                courseCode: row[headerIndexMap["Course Title"]!]?.value.toString() ?? "",
                courseName: row[headerIndexMap["Course Code"]!]?.value.toString() ?? "",
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