import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class AllStudentsUseCase implements UseCase<List<Student>, void>{
  final StudentRepository repository;

  AllStudentsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Student>>> execute(void params) async {
    return await repository.showAllStudents();
  }
}