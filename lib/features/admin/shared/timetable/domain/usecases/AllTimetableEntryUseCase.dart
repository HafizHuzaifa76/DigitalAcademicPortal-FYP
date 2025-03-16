import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/TimeTable.dart';
import '../repositories/TimeTableRepository.dart';

class AllTimeTablesUseCase implements UseCase<List<TimetableEntry>, void>{
  final TimeTableRepository repository;

  AllTimeTablesUseCase(this.repository);

  @override
  Future<Either<Fail, List<TimetableEntry>>> execute(void params) async {
    return await repository.showAllTimeTables();
  }
}