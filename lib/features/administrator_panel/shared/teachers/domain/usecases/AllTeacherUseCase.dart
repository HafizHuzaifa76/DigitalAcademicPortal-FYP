import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class AllTeachersUseCase implements UseCase<List<Teacher>, void>{
  final TeacherRepository repository;

  AllTeachersUseCase(this.repository);

  @override
  Future<Either<Fail, List<Teacher>>> execute(void params) async {
    return await repository.showAllTeachers();
  }
}