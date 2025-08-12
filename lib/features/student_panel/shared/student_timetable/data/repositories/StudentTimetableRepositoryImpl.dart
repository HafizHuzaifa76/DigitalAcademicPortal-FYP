import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../domain/repositories/StudentTimetableRepository.dart';
import '../datasources/StudentTimetableRemoteDataSource.dart';

class StudentTimetableRepositoryImpl implements StudentTimetableRepository {
  final StudentTimetableRemoteDataSource remoteDataSource;

  StudentTimetableRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> fetchStudentTimetable() async {
    try {
      final timetable = await remoteDataSource.fetchStudentTimetable();
      return Right(timetable);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
