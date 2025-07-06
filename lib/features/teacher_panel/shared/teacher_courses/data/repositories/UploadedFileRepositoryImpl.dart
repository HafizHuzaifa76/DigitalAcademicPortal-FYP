import 'package:dartz/dartz.dart';
import '../../domain/entities/UploadedFile.dart';
import '../../domain/repositories/UploadedFileRepository.dart';
import '../datasources/UploadedFileRemoteDataSource.dart';
import '../models/UploadedFileModel.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class UploadedFileRepositoryImpl implements UploadedFileRepository {
  final UploadedFileRemoteDataSource remoteDataSource;

  UploadedFileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<UploadedFile>>> getFiles(
      TeacherCourse course, FileType type) async {
    try {
      final files = await remoteDataSource.getFiles(course, type);
      return Right(files);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> uploadFile(
      TeacherCourse course, UploadedFile file) async {
    try {
      final fileModel = UploadedFileModel(
        id: file.id,
        fileName: file.fileName,
        fileUrl: file.fileUrl,
        fileSize: file.fileSize,
        uploadDate: file.uploadDate,
        type: file.type,
        courseId: file.courseId,
        courseName: file.courseName,
        courseSection: file.courseSection,
      );

      await remoteDataSource.uploadFile(course, fileModel);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> deleteFile(
      TeacherCourse course, String fileId) async {
    try {
      await remoteDataSource.deleteFile(course, fileId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
