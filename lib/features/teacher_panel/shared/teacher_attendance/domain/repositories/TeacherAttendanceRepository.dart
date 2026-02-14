import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';

abstract class TeacherAttendanceRepository {
  Future<Either<Fail, Map<String, List<Attendance>>>> getCourseAttendance(
    String semester,
    String section,
    String courseId,
    List<dynamic> studentIds,
  );

  Future<Either<Fail, void>> markAttendance(
    String semester,
    String section,
    List<Attendance> attendanceList,
  );
}
