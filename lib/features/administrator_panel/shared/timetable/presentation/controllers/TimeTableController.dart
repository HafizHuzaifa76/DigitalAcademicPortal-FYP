
import 'dart:io';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/FetchAssignedTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetCoursesUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetSectionsUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetTeachersUseCase.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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

  final ScrollController scrollController = ScrollController();
  RxDouble titlePadding = 70.0.obs;
  var isLoading = false.obs;

  var imageFile = Rxn<File>();
  var timeTableMap = <String, List<TimeTableEntry>>{}.obs;
  var sectionList = <Section>[].obs;
  var teacherList = <Teacher>[].obs;
  var coursesList = <SemesterCourse>[].obs;
  var selectedTeachers = <String, dynamic>{}.obs;
  var teachersIDMap = <String, Teacher>{}.obs;
  var coursesIDMap = <String, SemesterCourse>{}.obs;

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
      await showAllTimeTables(deptName, semester);
      // await fetchAssignedTeacher(deptName, semester, section);
    } finally {
      // isLoading(false);
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

  Future<void> addTimeTable(List<TimeTableEntry> timeTable, String deptName, String semester) async {
    EasyLoading.show(status: 'Adding...');

    try {
      isLoading(true);
      final result = await addTimeTableUseCase.execute(TimeTableParams(deptName: deptName, semester: semester, timeTable: timeTable));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (right) {

        Get.back();
        Get.back();
        showAllTimeTables(deptName, semester);
        Utils().showSuccessSnackBar('Success', 'TimeTable added successfully');
      });
    } finally {
      // clearFields();
      EasyLoading.dismiss();

    }
  }

  // Future<void> editTimeTable(TimeTableEntry updatedTimeTable) async {
  //   EasyLoading.show(status: 'Updating...');
  //   try {
  //     isLoading(true);
  //     final result = await editTimeTableUseCase.execute(updatedTimeTable);
  //
  //     result.fold((left) {
  //       String message = left.failure.toString();
  //       Utils().showErrorSnackBar('Error', message);
  //     }, (right) {
  //       // Update both lists
  //       int index = timeTableList.indexWhere((n) => n.id == updatedTimeTable.id);
  //       if (index != -1) {
  //         timeTableList[index] = updatedTimeTable;
  //       }
  //       Utils().showSuccessSnackBar('Success', 'TimeTable updated successfully.');
  //     });
  //   } finally {
  //     // clearFields();
  //     isLoading(false);
  //     EasyLoading.dismiss();
  //   }
  // }
  //
  // Future<void> deleteTimeTable(TimeTableEntry timeTable) async {
  //   EasyLoading.show(status: 'Deleting...');
  //   try {
  //     isLoading(true);
  //     final result = await deleteTimeTableUseCase.execute(timeTable);
  //
  //     result.fold((left) {
  //       String message = left.failure.toString();
  //       Utils().showErrorSnackBar('Error', message);
  //     }, (right) {
  //       timeTableList.remove(timeTable);
  //       Utils().showSuccessSnackBar('Success', 'TimeTable deleted successfully.');
  //     });
  //   } finally {
  //     isLoading(false);
  //     EasyLoading.dismiss();
  //   }
  // }

  Future<void> showAllTimeTables(String deptName, String semester) async {
    isLoading(true);
    final result = await allTimeTablesUseCase.execute(SemesterParams(deptName, semester));

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (timeTableList) {

      for(var section in sectionList){
        timeTableMap[section.sectionName] = [];
        timeTableMap[section.sectionName]?.addAll(
            timeTableList.where((item) => item.section == section.sectionName).toList()
        );

      }

      timeTableMap.entries.forEach((item)=> print('${item.key}: ${item.value.length}'));
      if (kDebugMode) {
        print('TimeTables fetched');
      }
    });

    isLoading(false);
  }

  Future<void> showSectionTimeTable(String deptName, String semester, String section) async {
    isLoading(true);
    final result = await allTimeTablesUseCase.execute(SemesterParams(deptName, semester));

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (timeTableList) {

      timeTableMap[section] = [];
      timeTableMap[section]?.addAll(
          timeTableList.where((item) => item.section == section).toList()
      );

      if (kDebugMode) {
        print('Section TimeTable fetched');
      }
    });

    isLoading(false);
  }

  Future<List<TimeTableEntry>> fetchTimeTableFromExcel(String semester, String section) async {
    try {
      // Open file picker to select an Excel file
      if (kDebugMode) {
        print('pick file');
      }
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

      List<TimeTableEntry> timeTableEntries = [];

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
        "Day",
        "Course Code",
        "Time Slot",
        "Room",
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

        var courseCode = row[headerIndexMap["Course Code"]!]?.value.toString() ?? "";
        var rowCourse = coursesIDMap[courseCode];
        if (rowCourse == null) {
          throw Exception('Invalid Course Code');
        }

        Teacher teacher = selectedTeachers['$section-${rowCourse.courseName}'];
        timeTableEntries.add(
            TimeTableEntry(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                courseCode: courseCode,
                courseName: rowCourse.courseName,
                teacherName: teacher.teacherName,
                teacherCNIC: teacher.teacherCNIC,
                room: row[headerIndexMap["Room"]!]?.value.toString() ?? "",
                timeSlot: row[headerIndexMap["Time Slot"]!]?.value.toString() ?? "",
                day: row[headerIndexMap["Day"]!]?.value.toString() ?? "",
                section: section,
                semester: semester
            )
        );
      }

      validateTimeTable(timeTableEntries, coursesIDMap.keys.toList());

      return timeTableEntries;
    } catch (e) {
      Utils().showErrorSnackBar('Error reading Excel file', '$e');
      return [];
    }
  }

  void validateTimeTable(List<TimeTableEntry> timetableEntries, List<String> coursesList) {
    Set<String> timetableCourseCodes = timetableEntries.map((e) => e.courseCode).toSet();
    List<String> missingCourses = coursesList.where((c) => !timetableCourseCodes.contains(c)).toList();

    // Store errors
    List<String> errors = [];

    if (missingCourses.isNotEmpty) {
      throw Exception("These courses are missing: ${missingCourses.join(', ')}");
      errors.add("Error: The following courses are missing from the timetable: ${missingCourses.join(', ')}");
    }

    // Maps to track conflicts
    Map<String, String> teacherSchedule = {}; // (teacherCNIC + timeSlot) -> courseCode
    Map<String, String> roomSchedule = {}; // (room + timeSlot) -> courseCode

    for (var entry in timetableEntries) {
      String teacherKey = "${entry.teacherCNIC}-${entry.timeSlot}-${entry.day}";
      String roomKey = "${entry.room}-${entry.timeSlot}-${entry.day}";

      // **Check if a teacher is assigned to multiple classes at the same time**
      if (teacherSchedule.containsKey(teacherKey)) {
        errors.add("Conflict: Teacher ${entry.teacherName} is assigned to multiple classes at ${entry.timeSlot} on ${entry.day}");
      } else {
        teacherSchedule[teacherKey] = entry.courseCode;
      }

      // **Check if a room is assigned to multiple classes at the same time**
      if (roomSchedule.containsKey(roomKey)) {
        errors.add("Conflict: Room ${entry.room} is assigned to multiple classes at ${entry.timeSlot} on ${entry.day}");
      } else {
        roomSchedule[roomKey] = entry.courseCode;
      }
    }

    // **Print errors or success message**
    if (errors.isNotEmpty) {
      String allErrors = '';
      for (var error in errors) {
        allErrors = allErrors + error;
      }
      throw Exception('Errors: $allErrors');
    }
  }

  Future<void> showAllSections(String deptName, String semester) async {

    isLoading(true);
    final result = await getSectionsUseCase.execute(SemesterParams(deptName, semester));

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (sections) async {
      sectionList.assignAll(sections);

      if (kDebugMode) {
        print('sections fetched');
      }

      // Fetch assigned teachers for each section after sections are fetched
      for (var section in sections) {
        await fetchAssignedTeacher(deptName, semester, section.sectionName);
      }

      Utils().showSuccessSnackBar(
        'Success',
        'Teacher Fetched successfully...',
      );
    });

  }


  Future<void> fetchAssignedTeacher(String deptName, String semester, String section) async {
    try {
      final result = await fetchAssignedTeachersUseCase.execute(FetchAssignedTeachersParams(deptName: deptName, semester: semester, section: section));
      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (assignedTeachersMap) {
        print('assignedTeachersMap: $assignedTeachersMap');

        for (var item in assignedTeachersMap.entries) {
          if(item.value != null) {
            selectedTeachers['$section-${item.key}'] = teachersIDMap[item.value];
          } else {
            selectedTeachers['$section-${item.key}'] = 'Not Selected';
          }
        }

        // Get.to(HomeScreen());
      });

    } catch(e) {
      Utils().showErrorSnackBar('Error', '$e');
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<void> showAllSemesterCourses(String deptName, String semester) async {
    final result = await getCoursesUseCase.execute(SemesterParams(deptName, semester));

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);

    }, (courses) {
      coursesList.assignAll(courses);

      for (var course in courses) {
        coursesIDMap[course.courseCode] = course;
      }

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


