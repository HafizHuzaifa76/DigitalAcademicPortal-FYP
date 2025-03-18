
import 'package:dartz/dartz.dart';
import '../entities/Template.dart';

abstract class TemplateRepository{

  Future<Either<Fail, MainTemplate>> addTemplate(MainTemplate notice);
  Future<Either<Fail, MainTemplate>> editTemplate(MainTemplate notice);
  Future<Either<Fail, void>> deleteTemplate(MainTemplate notice);
  Future<Either<Fail, List<MainTemplate>>> showAllTemplates();

}