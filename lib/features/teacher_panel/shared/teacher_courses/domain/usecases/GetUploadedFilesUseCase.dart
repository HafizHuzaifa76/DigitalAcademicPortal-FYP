import 'package:dartz/dartz.dart';
import '../entities/UploadedFile.dart';
import '../repositories/UploadedFileRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class GetUploadedFilesUseCase
    implements UseCase<List<UploadedFile>, GetFilesParams> {
  final UploadedFileRepository repository;

  GetUploadedFilesUseCase(this.repository);

  @override
  Future<Either<Fail, List<UploadedFile>>> execute(
      GetFilesParams params) async {
    return await repository.getFiles(params.course, params.type);
  }
}

class GetFilesParams {
  final TeacherCourse course;
  final FileType type;

  GetFilesParams({
    required this.course,
    required this.type,
  });
}
