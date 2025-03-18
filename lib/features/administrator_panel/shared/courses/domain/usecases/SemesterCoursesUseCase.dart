import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/SemesterCourse.dart';
import '../repositories/CourseRepository.dart';

class AllSemesterCoursesUseCase implements UseCase<List<SemesterCourse>, String>{
  final CourseRepository repository;

  AllSemesterCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(String deptName) async {
    return await repository.showAllSemesterCourses(deptName);
  }
}

class SemesterCoursesUseCase implements UseCase<List<SemesterCourse>, SemesterParams>{
  final CourseRepository repository;

  SemesterCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(SemesterParams semesterParams) async {
    return await repository.showSemesterCourses(semesterParams.deptName, semesterParams.semester);
  }
}

class AddSemesterCoursesUseCase implements UseCase<List<SemesterCourse>, List<SemesterCourse>>{
  final CourseRepository repository;

  AddSemesterCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(List<SemesterCourse> courses) async {
    return await repository.addSemesterCoursesList(courses);
  }
}