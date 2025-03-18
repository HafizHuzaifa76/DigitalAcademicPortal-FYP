import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/CalendarEvent.dart';
import '../repositories/CalendarEventRepository.dart';


class AddCalendarEventUseCase implements UseCase<CalendarEvent, CalendarEvent>{
  final CalendarEventRepository repository;

  AddCalendarEventUseCase(this.repository);

  @override
  Future<Either<Fail, CalendarEvent>> execute(CalendarEvent calendarEvent) async {
    return await repository.addCalendarEvent(calendarEvent);
  }
}