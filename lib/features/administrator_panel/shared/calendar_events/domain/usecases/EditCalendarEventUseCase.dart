
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../../../../../../shared/domain/entities/CalendarEvent.dart';
import '../repositories/CalendarEventRepository.dart';

class EditCalendarEventUseCase implements UseCase<CalendarEvent, CalendarEvent>{
  final CalendarEventRepository repository;

  EditCalendarEventUseCase(this.repository);

  @override
  Future<Either<Fail, CalendarEvent>> execute(CalendarEvent calendarEvent) async {
    return await repository.editCalendarEvent(calendarEvent);
  }
}