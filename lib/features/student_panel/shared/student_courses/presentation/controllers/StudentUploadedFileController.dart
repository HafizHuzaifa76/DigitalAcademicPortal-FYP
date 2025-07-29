import 'package:get/get.dart';
import '../../domain/entities/UploadedFile.dart';
import '../../domain/usecases/GetStudentUploadedFilesUseCase.dart';

class StudentUploadedFileController extends GetxController {
  final GetStudentUploadedFilesUseCase getFilesUseCase;
  StudentUploadedFileController({required this.getFilesUseCase});

  final files = <UploadedFile>[].obs;
  final isLoading = false.obs;

  Future<void> getFiles(String dept, String semester, String course,
      String section, FileType type) async {
    isLoading.value = true;
    try {
      final result =
          await getFilesUseCase(dept, semester, course, section, type);
      files.value = result;
    } catch (e) {
      files.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
