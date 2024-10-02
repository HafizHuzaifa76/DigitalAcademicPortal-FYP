import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Section.dart';
import '../repositories/SectionRepository.dart';

class DeleteSectionUseCase implements UseCase<void, SectionParams>{
  final SectionRepository repository;

  DeleteSectionUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(SectionParams sectionParams) async {
    return await repository.deleteSection(sectionParams.deptName, sectionParams.semester, sectionParams.section);
  }
}