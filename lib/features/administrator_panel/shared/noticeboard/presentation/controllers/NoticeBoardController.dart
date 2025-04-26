
import 'dart:io';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/AddNoticeUseCase.dart';
import '../../domain/usecases/AllNoticeUseCase.dart';
import '../../domain/usecases/DeleteNoticeUseCase.dart';
import '../../domain/usecases/EditNoticeUseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';

class NoticeBoardController extends GetxController {
  final AddNoticeUseCase addNoticeUseCase;
  final DeleteNoticeUseCase deleteNoticeUseCase;
  final EditNoticeUseCase editNoticeUseCase;
  final AllNoticesUseCase allNoticesUseCase;

  NoticeBoardController({
    required this.addNoticeUseCase,
    required this.deleteNoticeUseCase,
    required this.editNoticeUseCase,
    required this.allNoticesUseCase,
  });

  var noticeTitleController = TextEditingController();
  var noticeDescriptionController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  RxDouble titlePadding = 70.0.obs;
  var isLoading = false.obs;

  var imageFile = Rxn<File>();
  var noticeList = <MainNotice>[].obs;
  var filteredNoticeList = <MainNotice>[].obs;

  @override
  void onInit() {
    showAllNotices(); // Fetch the list of Notices when the controller is initialized
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

  /// Filter notices based on the query
  void filterNotices(String query) {
    if (query.isEmpty) {
      filteredNoticeList.assignAll(noticeList); // Reset to full list if no query
    } else {
      filteredNoticeList.assignAll(
        noticeList.where(
              (notice) => notice.title.toLowerCase().contains(query.toLowerCase()),
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

  Future<void> addNotice() async {
    EasyLoading.show(status: 'Adding...');
    var newNotice = MainNotice(
      id: DateTime.now().toIso8601String(), // Generate a unique ID
      title: noticeTitleController.text.trim(),
      description: noticeDescriptionController.text.trim(),
      datePosted: DateTime.now(),
    );

    try {
      isLoading(true);
      final result = await addNoticeUseCase.execute(newNotice);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (right) {
        noticeList.add(newNotice);
        filteredNoticeList.add(newNotice);
        Utils().showSuccessSnackBar('Success', 'Notice added successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> editNotice(MainNotice updatedNotice) async {
    EasyLoading.show(status: 'Updating...');
    try {
      isLoading(true);
      final result = await editNoticeUseCase.execute(updatedNotice);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        // Update both lists
        int index = noticeList.indexWhere((n) => n.id == updatedNotice.id);
        if (index != -1) {
          noticeList[index] = updatedNotice;
          filterNotices(''); // Refresh filtered list
        }
        Utils().showSuccessSnackBar('Success', 'Notice updated successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteNotice(MainNotice notice) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      isLoading(true);
      final result = await deleteNoticeUseCase.execute(notice);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        noticeList.remove(notice);
        filteredNoticeList.remove(notice);
        Utils().showSuccessSnackBar('Success', 'Notice deleted successfully.');
      });
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> showAllNotices() async {
    isLoading(true);
    final result = await allNoticesUseCase.execute(null);

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (notices) {
      noticeList.assignAll(notices);
      filteredNoticeList.assignAll(notices); // Initialize filtered list with all notices
      if (kDebugMode) {
        print('Notices fetched');
      }
    });

    isLoading(false);
  }

  void clearFields() {
    noticeTitleController.clear();
    noticeDescriptionController.clear();
    imageFile.value = null;
  }

  void updateNoticeDetails(MainNotice notice) {
    noticeTitleController.text = notice.title;
    noticeDescriptionController.text = notice.description;
  }
}


