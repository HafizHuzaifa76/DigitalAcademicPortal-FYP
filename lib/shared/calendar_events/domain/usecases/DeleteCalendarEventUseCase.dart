import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/CalendarEvent.dart';
import '../repositories/CalendarEventRepository.dart';

class DeleteCalendarEventUseCase implements UseCase<void, CalendarEvent>{
  final CalendarEventRepository repository;

  DeleteCalendarEventUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(CalendarEvent calendarEvent) async {
    return await repository.deleteCalendarEvent(calendarEvent);
  }
}