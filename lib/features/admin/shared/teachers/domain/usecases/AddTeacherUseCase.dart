import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class AddTeacherUseCase implements UseCase<Teacher, Teacher>{
  final TeacherRepository repository;

  AddTeacherUseCase(this.repository);

  @override
  Future<Either<Fail, Teacher>> execute(Teacher Teacher) async {
    return await repository.addTeacher(Teacher);
  }
}