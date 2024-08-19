
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class EditStudentUseCase implements UseCase<Student, Student>{
  final StudentRepository repository;

  EditStudentUseCase(this.repository);

  @override
  Future<Either<Fail, Student>> execute(Student student) async {
    return await repository.editStudent(student);
  }
}