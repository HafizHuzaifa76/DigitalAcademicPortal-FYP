import 'package:dartz/dartz.dart';
import '../entities/UploadedFile.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

abstract class UploadedFileRepository {
  Future<Either<Fail, List<UploadedFile>>> getFiles(
      TeacherCourse course, FileType type);
  Future<Either<Fail, void>> uploadFile(
      TeacherCourse course, UploadedFile file);
  Future<Either<Fail, void>> deleteFile(TeacherCourse course, String fileId);
}
