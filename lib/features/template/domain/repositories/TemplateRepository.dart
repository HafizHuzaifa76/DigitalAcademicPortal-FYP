
import 'package:dartz/dartz.dart';
import '../entities/Template.dart';

abstract class TemplateRepository{

  Future<Either<Fail, Template>> addTemplate(Template Template);
  Future<Either<Fail, Template>> editTemplate(Template Template);
  Future<Either<Fail, void>> deleteTemplate(Template Template);
  Future<Either<Fail, List<Template>>> showAllTemplates();

}