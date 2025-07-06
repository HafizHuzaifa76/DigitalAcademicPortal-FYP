import 'package:dartz/dartz.dart';
import '../entities/UploadedFile.dart';
import '../repositories/UploadedFileRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class UploadFileUseCase implements UseCase<void, UploadFileParams> {
  final UploadedFileRepository repository;

  UploadFileUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(UploadFileParams params) async {
    return await repository.uploadFile(params.course, params.file);
  }
}

class UploadFileParams {
  final TeacherCourse course;
  final UploadedFile file;

  UploadFileParams({
    required this.course,
    required this.file,
  });
}
