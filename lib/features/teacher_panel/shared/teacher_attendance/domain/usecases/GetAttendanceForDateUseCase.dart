import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/TeacherAttendance.dart';
import '../repositories/TeacherAttendanceRepository.dart';

class GetAttendanceForDateParams {
  final String courseId;
  final String courseSection;
  final DateTime date;

  GetAttendanceForDateParams({
    required this.courseId,
    required this.courseSection,
    required this.date,
  });
}

class GetAttendanceForDateUseCase
    implements UseCase<List<TeacherAttendance>, GetAttendanceForDateParams> {
  final TeacherAttendanceRepository repository;

  GetAttendanceForDateUseCase(this.repository);

  @override
  Future<Either<Fail, List<TeacherAttendance>>> execute(
      GetAttendanceForDateParams params) async {
    return await repository.getAttendanceForDate(
        params.courseId, params.courseSection, params.date);
  }
}
