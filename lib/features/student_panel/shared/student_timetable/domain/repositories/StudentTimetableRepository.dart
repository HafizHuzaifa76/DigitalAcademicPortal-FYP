import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';

abstract class StudentTimetableRepository {
  Future<Either<Fail, List<TimeTableEntry>>> fetchStudentTimetable();
}
