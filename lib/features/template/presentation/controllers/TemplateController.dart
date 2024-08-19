
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import '../../domain/usecases/AddTemplateUseCase.dart';
import '../../domain/usecases/AllTemplateUseCase.dart';
import '../../domain/usecases/DeleteTemplateUseCase.dart';
import '../../domain/usecases/EditTemplateUseCase.dart';

import '../../domain/entities/Template.dart';

class TemplateController extends GetxController{
  final AddTemplateUseCase addTemplateUseCase;
  final DeleteTemplateUseCase deleteTemplateUseCase;
  final EditTemplateUseCase editTemplateUseCase;
  final AllTemplatesUseCase allTemplatesUseCase;

  TemplateController({required this.addTemplateUseCase, required this.deleteTemplateUseCase, required this.editTemplateUseCase, required this.allTemplatesUseCase});

  @override
  void onInit() {
    showAllTemplates(); // Fetch the list of Templates when the controller is initialized
    super.onInit();
  }

  var totalSemestersController = TextEditingController();
  var totalStudentsController = TextEditingController();
  var totalTeachersController = TextEditingController();
  var TemplateNameController = TextEditingController();
  var TemplateCodeController = TextEditingController();
  var headOfTemplateController = TextEditingController();
  var contactPhoneController = TextEditingController();
  var isLoading = false.obs;

  var TemplateList = <Template>[].obs;

  Future<void> addTemplate(int TemplateID) async {
    var newTemplate = Template(
        id: 0
    );

    try {
      isLoading(true);
      final result = await addTemplateUseCase.execute(newTemplate);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Template added successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> editTemplate(int TemplateID) async {
    var newTemplate = Template(
        id: 0
    );

    try {
      isLoading(true);
      final result = await editTemplateUseCase.execute(newTemplate);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Template updated successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTemplate(Template Template) async {

    try {
      isLoading(true);
      final result = await deleteTemplateUseCase.execute(Template);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );
      }, (right) {
        Get.snackbar(
            'Success',
            'Template deleted successfully...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        // Get.to(HomeScreen());
      });

    } finally {
      isLoading(false);
    }
  }

  Future<void> showAllTemplates() async {
      isLoading(true);
      final result = await allTemplatesUseCase.execute(null);

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white)
        );

      }, (Templates) {
        TemplateList.assignAll(Templates);
        print('Templates fetched');
      });

      isLoading(false);
  }
}