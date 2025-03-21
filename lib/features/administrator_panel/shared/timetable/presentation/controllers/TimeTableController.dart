
import 'dart:io';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/FetchAssignedTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetCoursesUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetSectionsUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetTeachersUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../../../courses/domain/entities/SemesterCourse.dart';
import '../../../sections/domain/entities/Section.dart';
import '../../../teachers/domain/entities/Teacher.dart';
import '../../domain/entities/TimeTable.dart';
import '../../domain/usecases/AddTimetableEntryUseCase.dart';
import '../../domain/usecases/AllTimetableEntryUseCase.dart';
import '../../domain/usecases/DeleteTimetableEntryUseCase.dart';
import '../../domain/usecases/EditTimetableEntryUseCase.dart';

class TimeTableController extends GetxController {
  final AddTimeTableUseCase addTimeTableUseCase;
  final DeleteTimeTableUseCase deleteTimeTableUseCase;
  final EditTimeTableUseCase editTimeTableUseCase;
  final AllTimeTablesUseCase allTimeTablesUseCase;
  final GetAssignedTeachersUseCase fetchAssignedTeachersUseCase;
  final GetTimeTableCoursesUseCase getCoursesUseCase;
  final GetTimeTableTeachersUseCase getTeachersUseCase;
  final GetSectionsUseCase getSectionsUseCase;

  TimeTableController({
    required this.addTimeTableUseCase,
    required this.deleteTimeTableUseCase,
    required this.editTimeTableUseCase,
    required this.allTimeTablesUseCase,
    required this.fetchAssignedTeachersUseCase,
    required this.getCoursesUseCase,
    required this.getTeachersUseCase,
    required this.getSectionsUseCase,
  });

  var timeTableTitleController = TextEditingController();
  var timeTableDescriptionController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  RxDouble titlePadding = 70.0.obs;
  var isLoading = false.obs;

  var imageFile = Rxn<File>();
  var timeTableList = <TimetableEntry>[].obs;
  var filteredTimeTableList = <TimetableEntry>[].obs;
  var sectionList = <Section>[].obs;
  var teacherList = <Teacher>[].obs;
  var coursesList = <SemesterCourse>[].obs;
  var selectedTeachers = <String, dynamic>{}.obs;
  var teachersIDMap = <String, Teacher>{}.obs;

  @override
  void onInit() {
    // showAllTimeTables(); // Fetch the list of TimeTables when the controller is initialized
    scrollController.addListener(_adjustTitlePadding);
    super.onInit();
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

  Future<void> init(String deptName, String semester) async {
    try {
      isLoading(true);
      await showDeptTeachers(deptName);
      await showAllSemesterCourses(deptName, semester);
      await showAllSections(deptName, semester);

      // await fetchAssignedTeacher(deptName, semester, section);
    } finally {
      isLoading(false);
    }
  }

  /// Filter TimeTables based on the query
  void filterTimeTables(String query) {
    if (query.isEmpty) {
      filteredTimeTableList.assignAll(timeTableList); // Reset to full list if no query
    } else {
      filteredTimeTableList.assignAll(
        timeTableList.where(
              (timeTable) => timeTable.title.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        imageFile.value = File(pickedImage.path); // Update the observable
      } else {
        Utils().showErrorSnackBar('Error', 'No image selected.');
      }
    } catch (e) {
      Utils().showErrorSnackBar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> addTimeTable() async {
    EasyLoading.show(status: 'Adding...');
    var newTimeTable = TimetableEntry(
      id: DateTime.now().toIso8601String(), // Generate a unique ID
      title: timeTableTitleController.text.trim(),
      description: timeTableDescriptionController.text.trim(),
      datePosted: DateTime.now(),
    );

    try {
      isLoading(true);
      final result = await addTimeTableUseCase.execute(newTimeTable);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (right) {
        timeTableList.add(newTimeTable);
        filteredTimeTableList.add(newTimeTable);
        Utils().showSuccessSnackBar('Success', 'TimeTable added successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> editTimeTable(TimetableEntry updatedTimeTable) async {
    EasyLoading.show(status: 'Updating...');
    try {
      isLoading(true);
      final result = await editTimeTableUseCase.execute(updatedTimeTable);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        // Update both lists
        int index = timeTableList.indexWhere((n) => n.id == updatedTimeTable.id);
        if (index != -1) {
          timeTableList[index] = updatedTimeTable;
          filterTimeTables(''); // Refresh filtered list
        }
        Utils().showSuccessSnackBar('Success', 'TimeTable updated successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteTimeTable(TimetableEntry timeTable) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      isLoading(true);
      final result = await deleteTimeTableUseCase.execute(timeTable);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        timeTableList.remove(timeTable);
        filteredTimeTableList.remove(timeTable);
        Utils().showSuccessSnackBar('Success', 'TimeTable deleted successfully.');
      });
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> showAllTimeTables() async {
    isLoading(true);
    final result = await allTimeTablesUseCase.execute(null);

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (timeTables) {
      timeTableList.assignAll(timeTables);
      filteredTimeTableList.assignAll(timeTables); // Initialize filtered list with all TimeTables
      if (kDebugMode) {
        print('TimeTables fetched');
      }
    });

    isLoading(false);
  }

  Future<void> showAllSections(String deptName, String semester) async {
    isLoading(true);
    final result = await getSectionsUseCase.execute(SemesterParams(deptName, semester));

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);

    }, (sections) {
      sectionList.assignAll(sections);
      if (kDebugMode) {
        print('sections fetched');
      }
    });

    isLoading(false);
  }

  Future<void> fetchAssignedTeacher(String deptName, String semester, String section) async {
    try {
      print('assignedTeachersMap');
      isLoading(true);
      final result = await fetchAssignedTeachersUseCase.execute(FetchAssignedTeachersParams(deptName: deptName, semester: semester, section: section));

      result.fold((left) {
        String message = left.failure.toString();
        print('message');
        print(message);
        Utils().showErrorSnackBar('Error', message);
      }, (assignedTeachersMap) {
        print('assignedTeachersMap: $assignedTeachersMap');

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

  void clearFields() {
    timeTableTitleController.clear();
    timeTableDescriptionController.clear();
    imageFile.value = null;
  }

  void updateTimeTableDetails(TimetableEntry timeTable) {
    timeTableTitleController.text = timeTable.title;
    timeTableDescriptionController.text = timeTable.description;
  }
}


