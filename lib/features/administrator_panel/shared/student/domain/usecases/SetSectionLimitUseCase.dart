import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Student.dart';
import '../repositories/StudentRepository.dart';

class SetSectionLimitUseCase implements UseCase<void, SectionLimitParams>{
  final StudentRepository repository;

  SetSectionLimitUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(SectionLimitParams params) async {
    return await repository.setSectionLimit(params.deptName, params.semester, params.sectionLimit);
  }
}

