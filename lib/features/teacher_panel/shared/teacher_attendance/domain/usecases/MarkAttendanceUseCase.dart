import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../repositories/TeacherAttendanceRepository.dart';

class MarkAttendanceParams {
  final String semester;
  final String section;
  final List<Attendance> attendanceList;

  MarkAttendanceParams({
    required this.semester,
    required this.section,
    required this.attendanceList,
  });
}

class MarkAttendanceUseCase {
  final TeacherAttendanceRepository repository;

  MarkAttendanceUseCase(this.repository);

  Future<Either<Fail, void>> execute(MarkAttendanceParams params) async {
    return await repository.markAttendance(
      params.semester,
      params.section,
      params.attendanceList,
    );
  }
}
