import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/Grade.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class UpdateGradeParams {
  final TeacherCourse course;
  final Grade grade;

  UpdateGradeParams({
    required this.course,
    required this.grade,
  });
}

class UpdateGradeUseCase implements UseCase<void, UpdateGradeParams> {
  final TeacherGradeRepository repository;

  UpdateGradeUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(UpdateGradeParams params) async {
    return await repository.updateGrade(params.course, params.grade);
  }
}
