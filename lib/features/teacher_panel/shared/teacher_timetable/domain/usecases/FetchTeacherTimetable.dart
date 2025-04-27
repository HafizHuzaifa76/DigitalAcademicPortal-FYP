import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/TeacherTimeTableRepository.dart';

class FetchTeacherTimetable implements UseCase<List<TimeTableEntry>, String> {
  final TeacherTimeTableRepository repository;

  FetchTeacherTimetable(this.repository);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> execute(String teacherDept) async {
    return await repository.fetchTeacherTimetable(teacherDept);
  }
}