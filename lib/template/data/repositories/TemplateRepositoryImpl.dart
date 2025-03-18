
import 'package:dartz/dartz.dart';
import '../../domain/entities/Template.dart';
import '../../domain/repositories/TemplateRepository.dart';
import '../datasources/TemplateRemoteDataSource.dart';
import '../models/TemplateModel.dart';

class TemplateRepositoryImpl implements TemplateRepository{
  final TemplateRemoteDataSource templateRemoteDataSource;

  TemplateRepositoryImpl({required this.templateRemoteDataSource});


  @override
  Future<Either<Fail, MainTemplate>> addTemplate(MainTemplate template) async {
    try {
      return Right(await templateRemoteDataSource.addTemplate(TemplateModel.fromTemplate(template)));
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
  Future<Either<Fail, void>> deleteTemplate(MainTemplate template) async {
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
  Future<Either<Fail, MainTemplate>> editTemplate(MainTemplate template) async {
    try {
      return Right(await templateRemoteDataSource.editTemplate(TemplateModel.fromTemplate(template)));
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
  Future<Either<Fail, List<MainTemplate>>> showAllTemplates() async {
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