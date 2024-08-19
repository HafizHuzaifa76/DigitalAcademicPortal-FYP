import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Template.dart';
import '../repositories/TemplateRepository.dart';

class AddTemplateUseCase implements UseCase<Template, Template>{
  final TemplateRepository repository;

  AddTemplateUseCase(this.repository);

  @override
  Future<Either<Fail, Template>> execute(Template Template) async {
    return await repository.addTemplate(Template);
  }
}