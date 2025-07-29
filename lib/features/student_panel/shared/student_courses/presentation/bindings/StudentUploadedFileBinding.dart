import 'package:get/get.dart';
import '../../data/datasources/StudentUploadedFileRemoteDataSource.dart';
import '../../data/repositories/StudentUploadedFileRepositoryImpl.dart';
import '../../domain/repositories/StudentUploadedFileRepository.dart';
import '../../domain/usecases/GetStudentUploadedFilesUseCase.dart';
import '../controllers/StudentUploadedFileController.dart';

class StudentUploadedFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentUploadedFileRemoteDataSource>(
        () => StudentUploadedFileRemoteDataSourceImpl());
    Get.lazyPut<StudentUploadedFileRepository>(
        () => StudentUploadedFileRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => GetStudentUploadedFilesUseCase(Get.find()));
    Get.lazyPut(
        () => StudentUploadedFileController(getFilesUseCase: Get.find()));
  }
}
