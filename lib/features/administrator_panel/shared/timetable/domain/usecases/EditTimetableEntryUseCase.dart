
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class EditTimeTableUseCase implements UseCase<TimeTableEntry, TimeTableParams>{
  final TimeTableRepository repository;

  EditTimeTableUseCase(this.repository);

  @override
  Future<Either<Fail, TimeTableEntry>> execute(TimeTableParams params) async {
    return await repository.editTimeTable(params.timeTable.first, params.deptName, params.semester);
  }
}