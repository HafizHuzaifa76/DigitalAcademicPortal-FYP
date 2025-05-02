import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class AllTimeTablesUseCase implements UseCase<List<TimeTableEntry>, SemesterParams>{
  final TimeTableRepository repository;

  AllTimeTablesUseCase(this.repository);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> execute(SemesterParams params) async {
    return await repository.showAllTimeTables(params.deptName, params.semester);
  }
}