import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class DeleteTeacherUseCase implements UseCase<void, Teacher>{
  final TeacherRepository repository;

  DeleteTeacherUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(Teacher Teacher) async {
    return await repository.deleteTeacher(Teacher);
  }
}