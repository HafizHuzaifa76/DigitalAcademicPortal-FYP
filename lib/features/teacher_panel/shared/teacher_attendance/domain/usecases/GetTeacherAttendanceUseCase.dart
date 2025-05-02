import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/TeacherAttendance.dart';
import '../repositories/TeacherAttendanceRepository.dart';

class GetTeacherAttendanceUseCase implements UseCase<List<TeacherAttendance>, void> {
  final TeacherAttendanceRepository repository;

  GetTeacherAttendanceUseCase(this.repository);

  @override
  Future<Either<Fail, List<TeacherAttendance>>> execute(void params) async {
    return await repository.getTeacherAttendance();
  }
}