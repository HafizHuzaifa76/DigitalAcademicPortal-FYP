import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/TeacherCourseRepository.dart';

class GetStudentNamesParams {
  final List<dynamic> studentIds;
  final String courseDepartment;

  GetStudentNamesParams({
    required this.studentIds,
    required this.courseDepartment,
  });
}

class GetStudentNamesUseCase
    implements UseCase<Map<String, String>, GetStudentNamesParams> {
  final TeacherCourseRepository repository;

  GetStudentNamesUseCase(this.repository);

  @override
  Future<Either<Fail, Map<String, String>>> execute(
      GetStudentNamesParams params) async {
    return await repository.getStudentNames(
        params.studentIds, params.courseDepartment);
  }
}
