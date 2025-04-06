
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/SemesterCourse.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/AssignTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/GetCoursesUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/GetTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/domain/entities/Teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../domain/usecases/AddSectionUseCase.dart';
import '../../domain/usecases/AllSectionsUseCase.dart';
import '../../domain/usecases/DeleteSectionUseCase.dart';
import '../../domain/usecases/EditSectionUseCase.dart';

import '../../domain/entities/Section.dart';

class SectionController extends GetxController{
  final AddSectionUseCase addSectionUseCase;
  final DeleteSectionUseCase deleteSectionUseCase;
  final EditSectionUseCase editSectionUseCase;
  final AllSectionsUseCase allSectionsUseCase;
  final AssignTeachersUseCase assignTeachersUseCase;
  final EditAssignTeachersUseCase editAssignTeachersUseCase;
  final FetchAssignedTeachersUseCase fetchAssignedTeachersUseCase;
  final GetCoursesUseCase getCoursesUseCase;
  final GetTeachersUseCase getTeachersUseCase;

  SectionController({required this.addSectionUseCase, required this.deleteSectionUseCase, required this.getCoursesUseCase, required this.getTeachersUseCase, required this.editSectionUseCase, required this.allSectionsUseCase, required this.assignTeachersUseCase, required this.editAssignTeachersUseCase, required this.fetchAssignedTeachersUseCase});

  var totalSemestersController = TextEditingController();
  var totalStudentsController = TextEditingController();
  var totalTeachersController = TextEditingController();
  var sectionNameController = TextEditingController();
  var sectionCodeController = TextEditingController();
  var headOfSectionController = TextEditingController();
  var contactPhoneController = TextEditingController();
  var isLoading = false.obs;
  var isEdit = false.obs;

  var sectionList = <Section>[].obs;
  var teacherList = <Teacher>[].obs;
  var coursesList = <SemesterCourse>[].obs;
  var filteredSectionList = <Section>[].obs;
  var selectedTeachers = <String, dynamic>{}.obs;
  var teachersIDMap = <String, Teacher>{}.obs;

  void filterSections(String query) {
    if (query.isEmpty) {
      filteredSectionList.assignAll(sectionList);
    } else {
      filteredSectionList.assignAll(
        sectionList.where((section) => section.sectionName.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> init(String deptName, String semester, String section) async {
    try {
      isLoading(true);
      await showDeptTeachers(deptName);
      await showAllSemesterCourses(deptName, semester);
      await fetchAssignedTeacher(deptName, semester, section);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addSection(String deptName, String semester) async {
    var newSection = Section(
        sectionID: 'sectionID',
        sectionName: 'sectionName',
        shift: 'shift',
        totalStudents: 0, studentList: []
    );

    try {
      isLoading(true);
      final result = await addSectionUseCase.execute(SectionParams(deptName: deptName, semester: semester, section: newSection));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
          'Success',
          'Section added successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> editSection(String deptName, String semester, Section newSection) async {
    try {
      isLoading(true);
      final result = await editSectionUseCase.execute(SectionParams(deptName: deptName, semester: semester, section: newSection));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
          'Success',
          'Section updated successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteSection(String deptName, String semester, Section section) async {

    try {
      isLoading(true);
      final result = await deleteSectionUseCase.execute(SectionParams(deptName: deptName, semester: semester, section: section));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
          'Success',
          'Section deleted successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> showAllSections(String deptName, String semester) async {
      isLoading(true);
      final result = await allSectionsUseCase.execute(SemesterParams(deptName, semester));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (sections) {
        sectionList.assignAll(sections);
        filteredSectionList.assignAll(sections);
        if (kDebugMode) {
          print('sections fetched');
        }
      });

      isLoading(false);
  }

  void changeCourseTeacher(String courseCode, Teacher teacher) {
    selectedTeachers.value[courseCode] = teacher;
    print(selectedTeachers);
  }

  Future<void> assignTeacherToCourse(String deptName, String semester, String section) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'Assigning...');
      final result = await assignTeachersUseCase.execute(AssignTeachersParams(deptName: deptName, semester: semester, section: section, coursesTeachersMap: selectedTeachers));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        Utils().showSuccessSnackBar(
          'Success',
          'Teacher Assigned successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss(animation: true);
      isLoading(false);
    }
  }

  Future<void> editAssignedTeacher(String deptName, String semester, String section, String courseName, Teacher teacher) async {
    try {
      EasyLoading.show(status: 'Updating...');
      final result = await editAssignTeachersUseCase.execute(EditAssignTeachersParams(deptName: deptName, semester: semester, section: section, courseName: courseName, teacher: teacher));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        isLoading(true);
        changeCourseTeacher(courseName, teacher);

        Utils().showSuccessSnackBar(
          'Success',
          'Teacher Updated successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss(animation: true);
      isLoading(false);
    }
  }

  Future<void> fetchAssignedTeacher(String deptName, String semester, String section) async {
    try {
      final result = await fetchAssignedTeachersUseCase.execute(FetchAssignedTeachersParams(deptName: deptName, semester: semester, section: section));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (assignedTeachersMap) {

        if(assignedTeachersMap.isNotEmpty) {
          isEdit.value = true;
        }
        for (var item in assignedTeachersMap.entries) {
          selectedTeachers[item.key] = teachersIDMap[item.value];
        }

        Utils().showSuccessSnackBar(
          'Success',
          'Teacher Fetched successfully...',
        );
        // Get.to(HomeScreen());
      });

    } finally {
      EasyLoading.dismiss(animation: true);
      isLoading(false);
    }
  }

  Future<void> showAllSemesterCourses(String deptName, String semester) async {
      final result = await getCoursesUseCase.execute(SemesterParams(deptName, semester));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (courses) {
        coursesList.assignAll(courses);
        if (kDebugMode) {
          print('courses fetched');
        }
      });

  }

  Future<void> showDeptTeachers(String deptName) async {
      final result = await getTeachersUseCase.execute(deptName);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (teachers) {
        teacherList.assignAll(teachers);
        for (var teacher in teachers) {
          teachersIDMap[teacher.teacherCNIC] = teacher;
        }

        if (kDebugMode) {
          print('teachers fetched');
        }
      });

  }
}