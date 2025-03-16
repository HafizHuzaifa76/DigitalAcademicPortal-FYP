import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class AddTimeTableUseCase implements UseCase<TimetableEntry, TimetableEntry>{
  final TimeTableRepository repository;

  AddTimeTableUseCase(this.repository);

  @override
  Future<Either<Fail, TimetableEntry>> execute(TimetableEntry timeTable) async {
    return await repository.addTimeTable(timeTable);
  }
}