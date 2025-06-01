import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/StudentGrade.dart';
import '../repositories/StudentGradeRepository.dart';

class GetStudentGradesParams {
  final String studentId;
  final String courseId;

  GetStudentGradesParams({required this.studentId, required this.courseId});
}

class GetStudentGradesUseCase
    implements UseCase<List<StudentGrade>, GetStudentGradesParams> {
  final StudentGradeRepository repository;

  GetStudentGradesUseCase(this.repository);

  @override
  Future<Either<Fail, List<StudentGrade>>> execute(
      GetStudentGradesParams params) async {
    return await repository.getStudentGrades(params.studentId, params.courseId);
  }
}
