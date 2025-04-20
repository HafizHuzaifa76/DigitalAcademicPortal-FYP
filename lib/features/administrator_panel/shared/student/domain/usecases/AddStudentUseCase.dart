import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../../../../../../shared/domain/entities/Student.dart';
import '../repositories/StudentRepository.dart';

class AddStudentUseCase implements UseCase<Student, Student>{
  final StudentRepository repository;

  AddStudentUseCase(this.repository);

  @override
  Future<Either<Fail, Student>> execute(Student student) async {
    return await repository.addStudent(student);
  }
}