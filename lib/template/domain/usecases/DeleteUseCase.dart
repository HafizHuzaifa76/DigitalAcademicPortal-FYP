import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Template.dart';
import '../repositories/TemplateRepository.dart';

class DeleteTemplateUseCase implements UseCase<void, MainTemplate>{
  final TemplateRepository repository;

  DeleteTemplateUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(MainTemplate notice) async {
    return await repository.deleteTemplate(notice);
  }
}