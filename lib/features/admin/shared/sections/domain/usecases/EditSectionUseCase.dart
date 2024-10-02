
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Section.dart';
import '../repositories/SectionRepository.dart';

class EditSectionUseCase implements UseCase<Section, SectionParams>{
  final SectionRepository repository;

  EditSectionUseCase(this.repository);

  @override
  Future<Either<Fail, Section>> execute(SectionParams sectionParams) async {
    return await repository.editSection(sectionParams.deptName, sectionParams.semester, sectionParams.section);
  }
}