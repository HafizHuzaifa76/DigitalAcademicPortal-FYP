import 'package:dartz/dartz.dart';
import '../repositories/UploadedFileRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class DeleteFileUseCase implements UseCase<void, DeleteFileParams> {
  final UploadedFileRepository repository;

  DeleteFileUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(DeleteFileParams params) async {
    return await repository.deleteFile(params.course, params.fileId);
  }
}

class DeleteFileParams {
  final TeacherCourse course;
  final String fileId;

  DeleteFileParams({
    required this.course,
    required this.fileId,
  });
}
