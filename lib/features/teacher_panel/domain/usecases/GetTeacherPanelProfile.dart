import 'package:dartz/dartz.dart';
import '../../../../core/usecases/UseCase.dart';
import '../../../../shared/domain/entities/Teacher.dart';
import '../repositories/TeacherPanelRepository.dart';

class GetTeacherPanelProfile implements UseCase<Teacher, void> {
  final TeacherPanelRepository repository;

  GetTeacherPanelProfile(this.repository);

  @override
  Future<Either<Fail, Teacher>> execute(void params) async {
    return await repository.getTeacherPanelProfile();
  }
}