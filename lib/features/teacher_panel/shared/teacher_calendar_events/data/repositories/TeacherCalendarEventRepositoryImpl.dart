import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import '../../domain/repositories/TeacherCalendarEventRepository.dart';
import '../datasources/TeacherCalendarEventRemoteDataSource.dart';

class TeacherCalendarEventRepositoryImpl implements TeacherCalendarEventRepository {
  final TeacherCalendarEventRemoteDataSource remoteDataSource;

  TeacherCalendarEventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> getAllEvents() async {
    try {
      final eventMap = await remoteDataSource.getAllEvents();
      return Right(eventMap);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}