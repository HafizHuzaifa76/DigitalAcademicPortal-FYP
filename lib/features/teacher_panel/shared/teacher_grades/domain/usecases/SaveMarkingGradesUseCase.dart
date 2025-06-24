import 'package:dartz/dartz.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class SaveMarkingGradesParams {
  final TeacherCourse course;
  final String gradeId;
  final Map<String, dynamic> obtainedGrades;

  SaveMarkingGradesParams({
    required this.course,
    required this.gradeId,
    required this.obtainedGrades,
  });
}

class SaveMarkingGradesUseCase
    implements UseCase<void, SaveMarkingGradesParams> {
  final TeacherGradeRepository repository;

  SaveMarkingGradesUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(SaveMarkingGradesParams params) async {
    return await repository.saveMarkingGrades(
      params.course,
      params.gradeId,
      params.obtainedGrades,
    );
  }
}
