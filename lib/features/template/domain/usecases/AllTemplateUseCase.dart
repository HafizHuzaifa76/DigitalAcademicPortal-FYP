import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Template.dart';
import '../repositories/TemplateRepository.dart';

class AllTemplatesUseCase implements UseCase<List<Template>, void>{
  final TemplateRepository repository;

  AllTemplatesUseCase(this.repository);

  @override
  Future<Either<Fail, List<Template>>> execute(void params) async {
    return await repository.showAllTemplates();
  }
}