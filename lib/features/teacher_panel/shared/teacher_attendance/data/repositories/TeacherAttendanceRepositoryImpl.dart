import 'package:dartz/dartz.dart';
import '../../domain/repositories/TeacherAttendanceRepository.dart';
import '../datasources/TeacherAttendanceRemoteDataSource.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../../../../../../shared/data/models/AttendanceModel.dart';

class TeacherAttendanceRepositoryImpl implements TeacherAttendanceRepository {
  final TeacherAttendanceRemoteDataSource remoteDataSource;

  TeacherAttendanceRepositoryImpl(this.remoteDataSource);


  @override
  Future<Either<Fail, Map<String, List<Attendance>>>> getCourseAttendance(
    String semester,
    String section,
    String courseId,
    List<dynamic> studentIds,
  ) async {
    try {
      final result = await remoteDataSource.getCourseAttendance(
          semester, section, courseId);

      // Convert AttendanceModel to Attendance for each date
      final Map<String, List<Attendance>> convertedMap = {};
      result.forEach((date, modelList) {
        convertedMap[date] =
            modelList.map((model) => model as Attendance).toList();
      });

      return Right(convertedMap);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> markAttendance(
    String semester,
    String section,
    List<Attendance> attendanceList,
  ) async {
    try {
      final modelList = attendanceList
          .map((attendance) => AttendanceModel(
                id: attendance.id,
                course: attendance.course,
                studentId: attendance.studentId,
                date: attendance.date,
                isPresent: attendance.isPresent,
                remarks: attendance.remarks,
              ))
          .toList();
      await remoteDataSource.markAttendance(semester, section, modelList);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
