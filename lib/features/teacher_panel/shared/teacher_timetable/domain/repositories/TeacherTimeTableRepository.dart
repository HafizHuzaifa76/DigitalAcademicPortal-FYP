import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';

abstract class TeacherTimeTableRepository {
  Future<Either<Fail, List<TimeTableEntry>>> fetchTeacherTimetable(String teacherCNIC);
}