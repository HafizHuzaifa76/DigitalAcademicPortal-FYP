import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/TeacherAttendance.dart';
import '../repositories/TeacherAttendanceRepository.dart';

class MarkAttendanceUseCase implements UseCase<void, List<TeacherAttendance>> {
  final TeacherAttendanceRepository repository;

  MarkAttendanceUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(List<TeacherAttendance> params) async {
    return await repository.markAttendance(params);
  }
}
