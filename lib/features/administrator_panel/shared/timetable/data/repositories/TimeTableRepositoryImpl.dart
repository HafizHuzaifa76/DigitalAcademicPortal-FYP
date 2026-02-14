
import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../domain/repositories/TimeTableRepository.dart';
import '../datasources/TimeTableRemoteDataSource.dart';
import '../../../../../../shared/data/models/TimeTableEntryModel.dart';

class TimeTableRepositoryImpl implements TimeTableRepository{
  final TimeTableRemoteDataSource timeTableRemoteDataSource;

  TimeTableRepositoryImpl({required this.timeTableRemoteDataSource});

  @override
  Future<Either<Fail, void>> addTimeTable(List<TimeTableEntry> timetable, String deptName, String semester) async {
    try {
      return Right(await timeTableRemoteDataSource.addTimeTable(timetable, deptName, semester));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteTimeTable(TimeTableEntry entry, String deptName, String semester) async {
    try {
      return Right(await timeTableRemoteDataSource.deleteTimeTable(entry.id, deptName, semester));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, TimeTableEntry>> editTimeTable(TimeTableEntry timeTable, String deptName, String semester) async {
    try {
      return Right(await timeTableRemoteDataSource.editTimeTable(TimeTableEntryModel.fromTimeTable(timeTable), deptName, semester));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<TimeTableEntry>>> showAllTimeTables(String deptName, String semester) async {
    try {
      return Right(await timeTableRemoteDataSource.allTimeTables(deptName, semester));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<TimeTableEntry>>> showSectionTimeTables(String deptName, String semester, String section) async {
    try {
      return Right(await timeTableRemoteDataSource.sectionTimeTable(deptName, semester, section));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}