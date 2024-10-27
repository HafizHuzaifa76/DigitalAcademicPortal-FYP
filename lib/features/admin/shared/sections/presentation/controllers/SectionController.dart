
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  SectionController({required this.addSectionUseCase, required this.deleteSectionUseCase, required this.editSectionUseCase, required this.allSectionsUseCase});

  var totalSemestersController = TextEditingController();
  var totalStudentsController = TextEditingController();
  var totalTeachersController = TextEditingController();
  var sectionNameController = TextEditingController();
  var sectionCodeController = TextEditingController();
  var headOfSectionController = TextEditingController();
  var contactPhoneController = TextEditingController();
  var isLoading = false.obs;

  var sectionList = <Section>[].obs;
  var filteredSectionList = <Section>[].obs;

  void filterSections(String query) {
    if (query.isEmpty) {
      filteredSectionList.assignAll(sectionList);
    } else {
      filteredSectionList.assignAll(
        sectionList.where((section) => section.sectionName.toLowerCase().contains(query.toLowerCase())).toList(),
      );
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
            'Section added successfully...',
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

  Future<void> editSection(String deptName, String semester, Section newSection) async {

    try {
      isLoading(true);
      final result = await editSectionUseCase.execute(SectionParams(deptName: deptName, semester: semester, section: newSection));

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
            'Section updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white)
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
            'Section deleted successfully...',
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

  Future<void> showAllSections(String deptName, String semester) async {
      isLoading(true);
      final result = await allSectionsUseCase.execute(SemesterParams(deptName, semester));

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

      }, (sections) {
        sectionList.assignAll(sections);
        filteredSectionList.assignAll(sections);
        if (kDebugMode) {
          print('sections fetched');
        }
      });

      isLoading(false);
  }
}