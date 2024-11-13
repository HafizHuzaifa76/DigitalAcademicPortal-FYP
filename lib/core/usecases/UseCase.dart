import 'package:dartz/dartz.dart';

import '../../features/admin/shared/courses/domain/entities/Course.dart';
import '../../features/admin/shared/departments/domain/entities/Semester.dart';
import '../../features/admin/shared/sections/domain/entities/Section.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Fail, Type>> execute(Params params);
}

class CourseParams {
  final String deptName;
  final Course course;

  CourseParams(this.deptName, this.course);
}

class SemesterParams{
  final String deptName;
  final String semester;

  SemesterParams(this.deptName, this.semester);
}

class UpdateSemesterParams{
  final String deptName;
  final Semester semester;

  UpdateSemesterParams(this.deptName, this.semester);
}

class SectionParams{
  final String deptName;
  final String semester;
  final Section section;

  SectionParams({required this.deptName, required this.semester, required this.section});
}

class SectionLimitParams{
  final String deptName;
  final String semester;
  final int sectionLimit;

  SectionLimitParams({required this.deptName, required this.semester, required this.sectionLimit});
}

class TwoParams{
  final param1;
  final param2;

  TwoParams(this.param1, this.param2);
}

class ThreeParams{
  final param1;
  final param2;
  final param3;

  const ThreeParams({
    required this.param1,
    required this.param2,
    required this.param3,
  });
}