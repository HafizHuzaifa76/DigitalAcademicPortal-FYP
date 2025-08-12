import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/StudentTimetableRepository.dart';

class FetchStudentTimetable implements UseCase<List<TimeTableEntry>, void> {
  final StudentTimetableRepository repository;

  FetchStudentTimetable(this.repository);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> execute(void params) async {
    return await repository.fetchStudentTimetable();
  }
}
