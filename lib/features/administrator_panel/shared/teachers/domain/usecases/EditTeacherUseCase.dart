
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../../../../../../shared/domain/entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class EditTeacherUseCase implements UseCase<Teacher, Teacher>{
  final TeacherRepository repository;

  EditTeacherUseCase(this.repository);

  @override
  Future<Either<Fail, Teacher>> execute(Teacher Teacher) async {
    return await repository.editTeacher(Teacher);
  }
}