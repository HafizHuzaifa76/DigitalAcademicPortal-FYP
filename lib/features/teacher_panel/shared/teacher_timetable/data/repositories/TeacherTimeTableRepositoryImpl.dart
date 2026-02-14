import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../domain/repositories/TeacherTimeTableRepository.dart';
import '../datasources/TeacherTimeTableRemoteDataSource.dart';

class TeacherTimeTableRepositoryImpl implements TeacherTimeTableRepository {
  final TeacherTimeTableRemoteDataSource remoteDataSource;

  TeacherTimeTableRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> fetchTeacherTimetable() async {
    try {
      final timetable = await remoteDataSource.fetchTeacherTimetable();
      return Right(timetable);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}