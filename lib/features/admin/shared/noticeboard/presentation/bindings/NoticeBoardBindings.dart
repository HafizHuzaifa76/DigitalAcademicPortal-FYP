
import 'package:get/get.dart';

import '../../data/datasources/NoticeBoardRemoteDataSource.dart';
import '../../data/repositories/NoticeBoardRepositoryImpl.dart';
import '../../domain/repositories/NoticeBoardRepository.dart';
import '../../domain/usecases/AddNoticeUseCase.dart';
import '../../domain/usecases/AllNoticeUseCase.dart';
import '../../domain/usecases/DeleteNoticeUseCase.dart';
import '../../domain/usecases/EditNoticeUseCase.dart';
import '../controllers/NoticeBoardController.dart';

class NoticeBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NoticeRemoteDataSource>(() => NoticeRemoteDataSourceImpl());
    Get.lazyPut<NoticeRepository>(() => NoticeRepositoryImpl(noticeRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllNoticesUseCase(Get.find()));
    Get.lazyPut(() => AddNoticeUseCase(Get.find()));
    Get.lazyPut(() => EditNoticeUseCase(Get.find()));
    Get.lazyPut(() => DeleteNoticeUseCase(Get.find()));
    Get.lazyPut(() => NoticeBoardController(addNoticeUseCase: Get.find(), deleteNoticeUseCase: Get.find(), editNoticeUseCase: Get.find(), allNoticesUseCase: Get.find()));
  }

}