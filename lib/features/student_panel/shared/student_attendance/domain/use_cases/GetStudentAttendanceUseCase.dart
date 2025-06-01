import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/StudentAttendance.dart';
import '../repositories/StudentAttendanceRepository.dart';

class GetStudentAttendanceParams {
  final String studentId;
  final String courseId;

  GetStudentAttendanceParams({required this.studentId, required this.courseId});
}

class GetStudentAttendanceUseCase implements UseCase<List<StudentAttendance>, GetStudentAttendanceParams> {
  final StudentAttendanceRepository repository;

  GetStudentAttendanceUseCase(this.repository);

  @override
  Future<Either<Fail, List<StudentAttendance>>> execute(GetStudentAttendanceParams params) async {
    return await repository.getStudentAttendance(params.studentId, params.courseId);
  }
}