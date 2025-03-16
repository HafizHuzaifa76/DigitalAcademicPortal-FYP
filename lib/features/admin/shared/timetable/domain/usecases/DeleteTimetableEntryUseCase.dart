import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class DeleteTimeTableUseCase implements UseCase<void, TimetableEntry>{
  final TimeTableRepository repository;

  DeleteTimeTableUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(TimetableEntry timeTable) async {
    return await repository.deleteTimeTable(timeTable);
  }
}