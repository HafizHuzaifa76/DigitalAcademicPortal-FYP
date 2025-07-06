import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/TeacherTimeTableRepository.dart';

class FetchTeacherTimetable implements UseCase<List<TimeTableEntry>, void> {
  final TeacherTimeTableRepository repository;

  FetchTeacherTimetable(this.repository);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> execute(void params) async {
    return await repository.fetchTeacherTimetable();
  }
}
