import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../../../../../../shared/domain/entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class AddTeacherUseCase implements UseCase<Teacher, Teacher>{
  final TeacherRepository repository;

  AddTeacherUseCase(this.repository);

  @override
  Future<Either<Fail, Teacher>> execute(Teacher teacher) async {
    return await repository.addTeacher(teacher);
  }
}

class AddTeacherListUseCase implements UseCase<String, List<Teacher>>{
  final TeacherRepository repository;

  AddTeacherListUseCase(this.repository);

  @override
  Future<Either<Fail, String>> execute(List<Teacher> teacherList) async {
    return await repository.addTeacherList(teacherList);
  }
}