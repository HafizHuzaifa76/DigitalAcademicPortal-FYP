
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/usecases/SemesterCoursesUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../domain/usecases/AddCourseUseCase.dart';
import '../../domain/usecases/AllCourseUseCase.dart';
import '../../domain/usecases/DeleteCourseUseCase.dart';
import '../../domain/usecases/DeptCoursesUseCase.dart';
import '../../domain/usecases/EditCourseUseCase.dart';
import '../../domain/entities/Course.dart';

class CourseController extends GetxController{
  final AddCourseUseCase addCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;
  final EditCourseUseCase editCourseUseCase;
  final AllCoursesUseCase allCoursesUseCase;
  final DeptCoursesUseCase deptCoursesUseCase;
  final SemesterCoursesUseCase semesterCoursesUseCase;

  CourseController({required this.addCourseUseCase, required this.deleteCourseUseCase, required this.editCourseUseCase, required this.allCoursesUseCase, required this.deptCoursesUseCase, required this.semesterCoursesUseCase});

  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseNameController = TextEditingController();
  var isLoading = false.obs;

  var courseList = <Course>[].obs;
  var filteredCourseList = <Course>[].obs;
  var selectedTotalCourses = 5.obs;
  var selectedElectiveCourses = 0.obs;

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
    }
  }

  Future<void> addCourse(Course newCourse) async {

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
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss();
      showDeptCourses(newCourse.courseDept);
    }
  }

  Future<void> editCourse(Course newCourse) async {

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
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteCourse(String deptName, Course course) async {

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
        courseList.assignAll(courses);
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
}