
import 'package:dartz/dartz.dart';
import '../entities/Section.dart';

abstract class SectionRepository{

  Future<Either<Fail, Section>> addSection(String deptName, String semester, Section section);
  Future<Either<Fail, Section>> editSection(String deptName, String semester, Section section);
  Future<Either<Fail, void>> deleteSection(String deptName, String semester, Section section);
  Future<Either<Fail, List<Section>>> showAllSections(String deptName, String semester);

}