
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class EditTimeTableUseCase implements UseCase<TimetableEntry, TimetableEntry>{
  final TimeTableRepository repository;

  EditTimeTableUseCase(this.repository);

  @override
  Future<Either<Fail, TimetableEntry>> execute(TimetableEntry timeTable) async {
    return await repository.editTimeTable(timeTable);
  }
}