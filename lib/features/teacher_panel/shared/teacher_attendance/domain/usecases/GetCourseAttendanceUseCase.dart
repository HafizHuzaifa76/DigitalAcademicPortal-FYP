import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../repositories/TeacherAttendanceRepository.dart';

class GetCourseAttendanceParams {
  final String courseId;
  final List<dynamic> studentIds;
  final String semester;
  final String section;

  GetCourseAttendanceParams({
    required this.courseId,
    required this.studentIds,
    required this.semester,
    required this.section,
  });
}

class GetCourseAttendanceUseCase
    implements
        UseCase<Map<String, List<Attendance>>, GetCourseAttendanceParams> {
  final TeacherAttendanceRepository repository;

  GetCourseAttendanceUseCase(this.repository);

  @override
  Future<Either<Fail, Map<String, List<Attendance>>>> execute(
      GetCourseAttendanceParams params) async {
    return await repository.getCourseAttendance(
      params.semester,
      params.section,
      params.courseId,
      params.studentIds,
    );
  }
}
