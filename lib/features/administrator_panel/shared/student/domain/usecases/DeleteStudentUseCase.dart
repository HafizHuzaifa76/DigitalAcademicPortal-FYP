import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class DeleteStudentUseCase implements UseCase<void, Student>{
  final StudentRepository repository;

  DeleteStudentUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(Student student) async {
    return await repository.deleteStudent(student);
  }
}