import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';

abstract class StudentCalendarEventRepository {
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> getAllEvents();
}