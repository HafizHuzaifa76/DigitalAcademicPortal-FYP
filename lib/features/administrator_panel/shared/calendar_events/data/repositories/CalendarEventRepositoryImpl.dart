import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/CalendarEvent.dart';
import '../../domain/repositories/CalendarEventRepository.dart';
import '../datasources/CalendarEventRemoteDataSource.dart';
import '../../../../../../shared/data/models/CalendarEventModel.dart';

class CalendarEventRepositoryImpl implements CalendarEventRepository {
  final CalendarEventRemoteDataSource remoteDataSource;

  CalendarEventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, CalendarEvent>> addCalendarEvent(CalendarEvent calendarEvent) async {
    try {
      final eventModel = CalendarEventModel.fromEntity(calendarEvent);
      final addedEvent = await remoteDataSource.addCalendarEvent(eventModel);
      return Right(addedEvent.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Fail, CalendarEvent>> editCalendarEvent(CalendarEvent calendarEvent) async {
    try {
      final eventModel = CalendarEventModel.fromEntity(calendarEvent);
      final updatedEvent = await remoteDataSource.editCalendarEvent(eventModel);
      return Right(updatedEvent.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Fail, void>> deleteCalendarEvent(CalendarEvent calendarEvent) async {
    try {
      await remoteDataSource.deleteCalendarEvent(calendarEvent.id);
      return const Right(null);
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> showAllCalendarEvents() async {
    try {
      final eventMap = await remoteDataSource.allCalendarEvents();
      return Right(eventMap);
    } catch (e) {
      return _handleException(e);
    }
  }

  Either<Fail, T> _handleException<T>(dynamic e) {
    String message = e.toString();
    int startIndex = message.indexOf(']');
    if (startIndex != -1) {
      message = message.substring(startIndex + 1);
    }
    return Left(Fail(message));
  }
}
