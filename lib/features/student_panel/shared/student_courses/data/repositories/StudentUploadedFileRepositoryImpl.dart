import 'dart:async';
import '../../domain/entities/UploadedFile.dart';
import '../../domain/repositories/StudentUploadedFileRepository.dart';
import '../datasources/StudentUploadedFileRemoteDataSource.dart';

class StudentUploadedFileRepositoryImpl
    implements StudentUploadedFileRepository {
  final StudentUploadedFileRemoteDataSource remoteDataSource;
  StudentUploadedFileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UploadedFile>> getFiles(String dept, String semester,
      String course, String section, FileType type) {
    return remoteDataSource.getFiles(dept, semester, course, section, type);
  }
}
