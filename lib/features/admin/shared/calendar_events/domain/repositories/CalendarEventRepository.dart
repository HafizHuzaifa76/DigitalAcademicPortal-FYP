
import 'package:dartz/dartz.dart';
import '../entities/CalendarEvent.dart';

abstract class CalendarEventRepository{

  Future<Either<Fail, CalendarEvent>> addCalendarEvent(CalendarEvent calendarEvent);
  Future<Either<Fail, CalendarEvent>> editCalendarEvent(CalendarEvent calendarEvent);
  Future<Either<Fail, void>> deleteCalendarEvent(CalendarEvent calendarEvent);
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> showAllCalendarEvents();

}