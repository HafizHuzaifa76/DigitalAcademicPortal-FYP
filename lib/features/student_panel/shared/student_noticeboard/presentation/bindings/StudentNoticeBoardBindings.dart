
import 'package:get/get.dart';
import '../../data/repositories/StudentNoticeBoardRepositoryImpl.dart';
import '../../data/datasources/StudentNoticeBoardRemoteDataSource.dart';
import '../../domain/repositories/StudentNoticeBoardRepository.dart';
import '../../domain/usecases/StudentNoticeUseCase.dart';
import '../controllers/StudentNoticeBoardController.dart';

class NoticeBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<StudentNoticeRemoteDataSource>(() => StudentNoticeRemoteDataSourceImpl());
    Get.lazyPut<StudentNoticeRepository>(() => StudentNoticeRepositoryImpl(noticeRemoteDataSource: Get.find()));
    Get.lazyPut(() => StudentNoticesUseCase(Get.find()));
    Get.lazyPut(() => StudentNoticeBoardController(allNoticesUseCase: Get.find()));
  }

}