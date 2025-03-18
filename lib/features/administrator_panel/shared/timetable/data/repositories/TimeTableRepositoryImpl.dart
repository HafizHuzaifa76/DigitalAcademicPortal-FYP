
import 'package:dartz/dartz.dart';
import '../../domain/entities/TimeTable.dart';
import '../../domain/repositories/TimeTableRepository.dart';
import '../datasources/TimeTableRemoteDataSource.dart';
import '../models/TimeTableEntryModel.dart';

class TimeTableRepositoryImpl implements TimeTableRepository{
  final TimeTableRemoteDataSource timeTableRemoteDataSource;

  TimeTableRepositoryImpl({required this.timeTableRemoteDataSource});


  @override
  Future<Either<Fail, TimetableEntry>> addTimeTable(TimetableEntry entry) async {
    try {
      return Right(await timeTableRemoteDataSource.addTimeTable(TimeTableEntryModel.fromTimeTable(entry)));
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
  Future<Either<Fail, void>> deleteTimeTable(TimetableEntry entry) async {
    try {
      return Right(await timeTableRemoteDataSource.deleteTimeTable('id'));
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
  Future<Either<Fail, TimetableEntry>> editTimeTable(TimetableEntry timeTable) async {
    try {
      return Right(await timeTableRemoteDataSource.editTimeTable(TimeTableEntryModel.fromTimeTable(timeTable)));
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
  Future<Either<Fail, List<TimetableEntry>>> showAllTimeTables() async {
    try {
      return Right(await timeTableRemoteDataSource.allTimeTables());
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