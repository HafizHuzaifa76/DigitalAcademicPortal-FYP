
import 'package:dartz/dartz.dart';

import '../entities/TimeTable.dart';

abstract class TimeTableRepository{

  Future<Either<Fail, TimetableEntry>> addTimeTable(TimetableEntry timeTable);
  Future<Either<Fail, TimetableEntry>> editTimeTable(TimetableEntry timeTable);
  Future<Either<Fail, void>> deleteTimeTable(TimetableEntry timeTable);
  Future<Either<Fail, List<TimetableEntry>>> showAllTimeTables();

}