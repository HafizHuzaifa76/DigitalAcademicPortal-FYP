
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class FetchSectionTimeTable implements UseCase<List<TimeTableEntry>, SectionParams2>{
  final TimeTableRepository repository;

  FetchSectionTimeTable(this.repository);

  @override
  Future<Either<Fail, List<TimeTableEntry>>> execute(SectionParams2 params) async {
    return await repository.showSectionTimeTables(params.deptName, params.semester, params.section);
  }
}