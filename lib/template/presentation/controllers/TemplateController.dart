
import 'dart:io';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/AddUseCase.dart';
import '../../domain/usecases/AllUseCase.dart';
import '../../domain/usecases/DeleteUseCase.dart';
import '../../domain/usecases/EditUseCase.dart';
import '../../domain/entities/Template.dart';

class TemplateController extends GetxController {
  final AddTemplateUseCase addTemplateUseCase;
  final DeleteTemplateUseCase deleteTemplateUseCase;
  final EditTemplateUseCase editTemplateUseCase;
  final AllTemplatesUseCase allTemplatesUseCase;

  TemplateController({
    required this.addTemplateUseCase,
    required this.deleteTemplateUseCase,
    required this.editTemplateUseCase,
    required this.allTemplatesUseCase,
  });

  var templateTitleController = TextEditingController();
  var templateDescriptionController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  RxDouble titlePadding = 70.0.obs;
  var isLoading = false.obs;

  var imageFile = Rxn<File>();
  var TemplateList = <MainTemplate>[].obs;
  var filteredTemplateList = <MainTemplate>[].obs;

  @override
  void onInit() {
    showAllTemplates(); // Fetch the list of Templates when the controller is initialized
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

  /// Filter Templates based on the query
  void filterTemplates(String query) {
    if (query.isEmpty) {
      filteredTemplateList.assignAll(TemplateList); // Reset to full list if no query
    } else {
      filteredTemplateList.assignAll(
        TemplateList.where(
              (Template) => Template.title.toLowerCase().contains(query.toLowerCase()),
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

  Future<void> addTemplate() async {
    EasyLoading.show(status: 'Adding...');
    var newTemplate = MainTemplate(
      id: DateTime.now().toIso8601String(), // Generate a unique ID
      title: templateTitleController.text.trim(),
      description: templateDescriptionController.text.trim(),
      datePosted: DateTime.now(),
    );

    try {
      isLoading(true);
      final result = await addTemplateUseCase.execute(newTemplate);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (right) {
        TemplateList.add(newTemplate);
        filteredTemplateList.add(newTemplate);
        Utils().showSuccessSnackBar('Success', 'Template added successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> editTemplate(MainTemplate updatedTemplate) async {
    EasyLoading.show(status: 'Updating...');
    try {
      isLoading(true);
      final result = await editTemplateUseCase.execute(updatedTemplate);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        // Update both lists
        int index = TemplateList.indexWhere((n) => n.id == updatedTemplate.id);
        if (index != -1) {
          TemplateList[index] = updatedTemplate;
          filterTemplates(''); // Refresh filtered list
        }
        Utils().showSuccessSnackBar('Success', 'Template updated successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteTemplate(MainTemplate Template) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      isLoading(true);
      final result = await deleteTemplateUseCase.execute(Template);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        TemplateList.remove(Template);
        filteredTemplateList.remove(Template);
        Utils().showSuccessSnackBar('Success', 'Template deleted successfully.');
      });
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> showAllTemplates() async {
    isLoading(true);
    final result = await allTemplatesUseCase.execute(null);

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (Templates) {
      TemplateList.assignAll(Templates);
      filteredTemplateList.assignAll(Templates); // Initialize filtered list with all Templates
      if (kDebugMode) {
        print('Templates fetched');
      }
    });

    isLoading(false);
  }

  void clearFields() {
    templateTitleController.clear();
    templateDescriptionController.clear();
    imageFile.value = null;
  }

  void updateTemplateDetails(MainTemplate Template) {
    templateTitleController.text = Template.title;
    templateDescriptionController.text = Template.description;
  }
}


