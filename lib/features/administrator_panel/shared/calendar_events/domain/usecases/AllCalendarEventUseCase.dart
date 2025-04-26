import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/CalendarEvent.dart';
import '../repositories/CalendarEventRepository.dart';

class AllCalendarEventsUseCase implements UseCase<Map<DateTime, List<CalendarEvent>>, void>{
  final CalendarEventRepository repository;

  AllCalendarEventsUseCase(this.repository);

  @override
  Future<Either<Fail, Map<DateTime, List<CalendarEvent>>>> execute(void params) async {
    return await repository.showAllCalendarEvents();
  }
}