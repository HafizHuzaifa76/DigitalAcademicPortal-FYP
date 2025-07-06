import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Data sources
import '../../data/datasources/UploadedFileRemoteDataSource.dart';

// Repositories
import '../../data/repositories/UploadedFileRepositoryImpl.dart';
import '../../domain/repositories/UploadedFileRepository.dart';

// Use cases
import '../../domain/usecases/GetUploadedFilesUseCase.dart';
import '../../domain/usecases/UploadFileUseCase.dart';
import '../../domain/usecases/DeleteFileUseCase.dart';

// Controllers
import '../controllers/UploadedFileController.dart';

class UploadedFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseFirestore.instance);

    // Data sources
    Get.lazyPut<UploadedFileRemoteDataSource>(
      () => UploadedFileRemoteDataSourceImpl(),
    );

    // Repositories
    Get.lazyPut<UploadedFileRepository>(
      () => UploadedFileRepositoryImpl(remoteDataSource: Get.find()),
    );

    // Use cases
    Get.lazyPut(() => GetUploadedFilesUseCase(Get.find()));
    Get.lazyPut(() => UploadFileUseCase(Get.find()));
    Get.lazyPut(() => DeleteFileUseCase(Get.find()));

    // Controllers - Use Get.put() to ensure persistence across navigation
    Get.put<UploadedFileController>(
      UploadedFileController(
        getFilesUseCase: Get.find(),
        uploadFileUseCase: Get.find(),
        deleteFileUseCase: Get.find(),
      ),
      permanent: true, // Keep the controller alive even when page is disposed
    );
  }
}
