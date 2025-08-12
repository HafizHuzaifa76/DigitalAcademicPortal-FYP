import 'dart:io';

import 'package:digital_academic_portal/core/services/NotificationService.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/services/CloudinaryService.dart';
import '../../domain/usecases/AddNoticeUseCase.dart';
import '../../domain/usecases/AllNoticesUseCase.dart';
import '../../domain/usecases/DeleteNoticeUseCase.dart';
import '../../domain/usecases/EditNoticeUseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../../domain/usecases/AddDepartmentNoticeUseCase.dart';
import '../../domain/usecases/EditDepartmentNoticeUseCase.dart';
import '../../domain/usecases/DeleteDepartmentNoticeUseCase.dart';
import '../../domain/usecases/AllDepartmentNoticesUseCase.dart';

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
  final Rx<File?> pickedFile = Rx<File?>(null);
  var noticeList = <MainNotice>[].obs;
  var filteredNoticeList = <MainNotice>[].obs;

  // Department-level notices
  final AddDepartmentNoticeUseCase? addDepartmentNoticeUseCase =
      Get.isRegistered<AddDepartmentNoticeUseCase>()
          ? Get.find<AddDepartmentNoticeUseCase>()
          : null;
  final EditDepartmentNoticeUseCase? editDepartmentNoticeUseCase =
      Get.isRegistered<EditDepartmentNoticeUseCase>()
          ? Get.find<EditDepartmentNoticeUseCase>()
          : null;
  final DeleteDepartmentNoticeUseCase? deleteDepartmentNoticeUseCase =
      Get.isRegistered<DeleteDepartmentNoticeUseCase>()
          ? Get.find<DeleteDepartmentNoticeUseCase>()
          : null;
  final AllDepartmentNoticesUseCase? allDepartmentNoticesUseCase =
      Get.isRegistered<AllDepartmentNoticesUseCase>()
          ? Get.find<AllDepartmentNoticesUseCase>()
          : null;

  @override
  void onInit() {
    // Fetch the list of Notices when the controller is initialized
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
      filteredNoticeList
          .assignAll(noticeList); // Reset to full list if no query
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

    String? fileUrl;
    if (imageFile.value != null) {
      fileUrl = await uploadImageToCloudinary(imageFile.value!);
    }

    var newNotice = MainNotice(
        id: DateTime.now().toIso8601String(), // Generate a unique ID
        title: noticeTitleController.text.trim(),
        description: noticeDescriptionController.text.trim(),
        datePosted: DateTime.now(),
        imageUrl: fileUrl);

    try {
      isLoading(true);
      final result = await addNoticeUseCase.execute(newNotice);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (right) async {
        noticeList.insert(0, newNotice);
        filteredNoticeList.insert(0, newNotice);
        await sendFCMMessage('university', 'Notice',
            'A new notice from university', 'studentNoticeBoard');
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
      filteredNoticeList
          .assignAll(notices); // Initialize filtered list with all notices
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

  // Department-level notices
  void filterDepartmentNotices(String query) {
    if (query.isEmpty) {
      filteredNoticeList.assignAll(noticeList);
    } else {
      filteredNoticeList.assignAll(
        noticeList.where(
          (notice) => notice.title.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> showAllDepartmentNotices(String department) async {
    if (allDepartmentNoticesUseCase == null) return;
    isLoading(true);
    final result = await allDepartmentNoticesUseCase!.execute(department);
    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (notices) {
      noticeList.assignAll(notices);
      filteredNoticeList.assignAll(notices);
    });
    isLoading(false);
  }

  Future<void> addDepartmentNotice(String department) async {
    if (addDepartmentNoticeUseCase == null) return;
    EasyLoading.show(status: 'Adding...');
    String? fileUrl;
    if (imageFile.value != null) {
      fileUrl = await uploadImageToCloudinary(imageFile.value!);
    }
    var newNotice = MainNotice(
        id: DateTime.now().toIso8601String(),
        title: noticeTitleController.text.trim(),
        description: noticeDescriptionController.text.trim(),
        datePosted: DateTime.now(),
        imageUrl: fileUrl,
        department: department);
    try {
      isLoading(true);
      final result = await addDepartmentNoticeUseCase!
          .execute({'department': department, 'notice': newNotice});
      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) async {
        noticeList.insert(0, newNotice);
        filteredNoticeList.insert(0, newNotice);

        final deptTopic = 'Dept-$department'.toLowerCase().replaceAll(" ", "-");
        await sendFCMMessage(deptTopic, 'Notice',
            'A new notice from Department', 'studentNoticeBoard');
        Utils().showSuccessSnackBar('Success', 'Notice added successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> editDepartmentNotice(
      String department, MainNotice updatedNotice) async {
    if (editDepartmentNoticeUseCase == null) return;
    EasyLoading.show(status: 'Updating...');
    try {
      isLoading(true);
      final result = await editDepartmentNoticeUseCase!
          .execute({'department': department, 'notice': updatedNotice});
      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {
        int index = noticeList.indexWhere((n) => n.id == updatedNotice.id);
        if (index != -1) {
          noticeList[index] = updatedNotice;
          filterDepartmentNotices('');
        }
        Utils().showSuccessSnackBar('Success', 'Notice updated successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteDepartmentNotice(
      String department, MainNotice notice) async {
    if (deleteDepartmentNoticeUseCase == null) return;
    EasyLoading.show(status: 'Deleting...');
    try {
      isLoading(true);
      final result = await deleteDepartmentNoticeUseCase!
          .execute({'department': department, 'notice': notice});
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
}
