import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class SemesterStudentsUseCase implements UseCase<List<Student>, SemesterParams>{
  final StudentRepository repository;

  SemesterStudentsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Student>>> execute(SemesterParams params) async {
    return await repository.showSemesterStudents(params.deptName, params.semester);
  }
}

