import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../repositories/StudentAttendanceRepository.dart';

class GetStudentAttendanceParams {
  final String courseId;

  GetStudentAttendanceParams({required this.courseId});
}

class GetStudentAttendanceUseCase
    implements UseCase<List<Attendance>, GetStudentAttendanceParams> {
  final StudentAttendanceRepository repository;

  GetStudentAttendanceUseCase(this.repository);

  @override
  Future<Either<Fail, List<Attendance>>> execute(
      GetStudentAttendanceParams params) async {
    return await repository.getStudentAttendance(params.courseId);
  }
}
