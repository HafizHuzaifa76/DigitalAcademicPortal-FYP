
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/admin/shared/teachers/domain/entities/Teacher.dart';
import '../entities/Section.dart';

abstract class SectionRepository{

  Future<Either<Fail, Section>> addSection(String deptName, String semester, Section section);
  Future<Either<Fail, Section>> editSection(String deptName, String semester, Section section);
  Future<Either<Fail, void>> deleteSection(String deptName, String semester, Section section);
  Future<Either<Fail, Map<String, String?>>> fetchAssignedTeachers(String deptName, String semester, String section);
  Future<Either<Fail, void>> editAssignedTeachers(String deptName, String semester, String section, String courseName, Teacher teacher);
  Future<Either<Fail, void>> assignTeacherToCourses(String deptName, String semester, String section, Map<String, dynamic> coursesTeachersMap);
  Future<Either<Fail, List<Section>>> showAllSections(String deptName, String semester);

}