
import 'package:dartz/dartz.dart';

import '../entities/TimeTable.dart';

abstract class TimeTableRepository{

  Future<Either<Fail, void>> addTimeTable(List<TimeTableEntry> timeTable, String deptName, String semester);
  Future<Either<Fail, TimeTableEntry>> editTimeTable(TimeTableEntry timeTable, String deptName, String semester);
  Future<Either<Fail, void>> deleteTimeTable(TimeTableEntry timeTable, String deptName, String semester);
  Future<Either<Fail, List<TimeTableEntry>>> showAllTimeTables(String deptName, String semester);

}