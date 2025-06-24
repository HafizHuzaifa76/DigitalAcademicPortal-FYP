import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../repositories/TeacherGradeRepository.dart';

class DeleteGradeParams {
  final TeacherCourse course;
  final String gradeId;

  const DeleteGradeParams({
    required this.course,
    required this.gradeId,
  });
}

class DeleteGradeUseCase implements UseCase<void, DeleteGradeParams> {
  final TeacherGradeRepository repository;

  DeleteGradeUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(DeleteGradeParams params) async {
    return await repository.deleteGrade(params.course, params.gradeId);
  }
}
