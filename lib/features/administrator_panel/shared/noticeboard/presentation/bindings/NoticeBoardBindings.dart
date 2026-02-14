import 'package:get/get.dart';

import '../../data/datasources/NoticeBoardRemoteDataSource.dart';
import '../../data/repositories/NoticeBoardRepositoryImpl.dart';
import '../../domain/repositories/NoticeBoardRepository.dart';
import '../../domain/usecases/AddNoticeUseCase.dart';
import '../../domain/usecases/AllNoticesUseCase.dart';
import '../../domain/usecases/DeleteNoticeUseCase.dart';
import '../../domain/usecases/EditNoticeUseCase.dart';
import '../controllers/NoticeBoardController.dart';
import '../../data/datasources/DepartmentNoticeRemoteDataSource.dart';
import '../../data/repositories/DepartmentNoticeBoardRepositoryImpl.dart';
import '../../domain/repositories/DepartmentNoticeBoardRepository.dart';
import '../../domain/usecases/AddDepartmentNoticeUseCase.dart';
import '../../domain/usecases/AllDepartmentNoticesUseCase.dart';
import '../../domain/usecases/DeleteDepartmentNoticeUseCase.dart';
import '../../domain/usecases/EditDepartmentNoticeUseCase.dart';

class NoticeBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoticeBoardRemoteDataSource>(
        () => NoticeRemoteDataSourceImpl());
    Get.lazyPut<NoticeBoardRepository>(
        () => NoticeBoardRepositoryImpl(noticeRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllNoticesUseCase(Get.find()));
    Get.lazyPut(() => AddNoticeUseCase(Get.find()));
    Get.lazyPut(() => EditNoticeUseCase(Get.find()));
    Get.lazyPut(() => DeleteNoticeUseCase(Get.find()));
    Get.lazyPut<DepartmentNoticeRemoteDataSource>(
        () => DepartmentNoticeRemoteDataSourceImpl());
    Get.lazyPut<DepartmentNoticeBoardRepository>(() =>
        DepartmentNoticeBoardRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => AllDepartmentNoticesUseCase(
        Get.find<DepartmentNoticeBoardRepository>()));
    Get.lazyPut(() => AddDepartmentNoticeUseCase(
        Get.find<DepartmentNoticeBoardRepository>()));
    Get.lazyPut(() => EditDepartmentNoticeUseCase(
        Get.find<DepartmentNoticeBoardRepository>()));
    Get.lazyPut(() => DeleteDepartmentNoticeUseCase(
        Get.find<DepartmentNoticeBoardRepository>()));
    Get.lazyPut(() => NoticeBoardController(
        addNoticeUseCase: Get.find(),
        deleteNoticeUseCase: Get.find(),
        editNoticeUseCase: Get.find(),
        allNoticesUseCase: Get.find()));
  }
}
