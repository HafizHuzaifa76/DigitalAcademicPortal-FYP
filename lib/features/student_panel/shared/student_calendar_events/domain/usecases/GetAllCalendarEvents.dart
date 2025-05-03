import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import '../repositories/StudentCalendarEventRepository.dart';

class GetAllCalendarEvents implements UseCase<Map<DateTime, List<CalendarEvent>>, void> {
  final StudentCalendarEventRepository repository;

  GetAllCalendarEvents(this.repository);

  @override
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> execute(void params) async {
    return await repository.getAllEvents();
  }
}