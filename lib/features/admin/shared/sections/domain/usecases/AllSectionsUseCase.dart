import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Section.dart';
import '../repositories/SectionRepository.dart';

class AllSectionsUseCase implements UseCase<List<Section>, SemesterParams>{
  final SectionRepository repository;

  AllSectionsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Section>>> execute(SemesterParams params) async {
    return await repository.showAllSections(params.deptName, params.semester);
  }
}