import 'dart:async';
import '../entities/UploadedFile.dart';
import '../repositories/StudentUploadedFileRepository.dart';

class GetStudentUploadedFilesUseCase {
  final StudentUploadedFileRepository repository;
  GetStudentUploadedFilesUseCase(this.repository);

  Future<List<UploadedFile>> call(String dept, String semester, String course,
      String section, FileType type) {
    return repository.getFiles(dept, semester, course, section, type);
  }
}
