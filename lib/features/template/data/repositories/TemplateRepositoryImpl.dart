
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/template/data/datasources/TemplateRemoteDataSource.dart';
import '../../domain/entities/Template.dart';
import '../../domain/repositories/TemplateRepository.dart';
import '../models/TemplateModel.dart';

class TemplateRepositoryImpl implements TemplateRepository{
  final TemplateRemoteDataSource templateRemoteDataSource;

  TemplateRepositoryImpl({required this.templateRemoteDataSource});


  @override
  Future<Either<Fail, Template>> addTemplate(Template Template) async {
    try {
      return Right(await templateRemoteDataSource.addTemplate(TemplateModel.fromTemplate(Template)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteTemplate(Template Template) async {
    try {
      return Right(await templateRemoteDataSource.deleteTemplate('id'));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, Template>> editTemplate(Template Template) async {
    try {
      return Right(await templateRemoteDataSource.editTemplate(TemplateModel.fromTemplate(Template)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<Template>>> showAllTemplates() async {
    try {
      return Right(await templateRemoteDataSource.allTemplates());
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}