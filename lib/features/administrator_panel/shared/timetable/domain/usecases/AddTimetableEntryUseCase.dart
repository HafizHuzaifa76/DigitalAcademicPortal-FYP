import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class AddTimeTableUseCase implements UseCase<void, TimeTableParams>{
  final TimeTableRepository repository;

  AddTimeTableUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(TimeTableParams params) async {
    return await repository.addTimeTable(params.timeTable, params.deptName, params.semester);
  }
}