
import 'package:dartz/dartz.dart';
import '../../domain/entities/Section.dart';
import '../../domain/repositories/SectionRepository.dart';
import '../datasources/SectionRemoteDataSource.dart';
import '../models/SectionModel.dart';

class SectionRepositoryImpl implements SectionRepository{
  final SectionRemoteDataSource sectionRemoteDataSource;

  SectionRepositoryImpl({required this.sectionRemoteDataSource});


  @override
  Future<Either<Fail, Section>> addSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.addSection(deptName, semester, SectionModel.fromSection(section)));
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
  Future<Either<Fail, void>> deleteSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.deleteSection(deptName, semester, section.sectionID));
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
  Future<Either<Fail, Section>> editSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.editSection(deptName, semester, SectionModel.fromSection(section)));
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
  Future<Either<Fail, List<Section>>> showAllSections(String deptName, String semester) async {
    try {
      return Right(await sectionRemoteDataSource.allSections(deptName, semester));
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