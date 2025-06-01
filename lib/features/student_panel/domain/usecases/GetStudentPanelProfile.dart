import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import '../../../../core/usecases/UseCase.dart';
import '../repositories/StudentPanelRepository.dart';

class GetStudentPanelProfile implements UseCase<Student, void> {
  final StudentPanelRepository repository;

  GetStudentPanelProfile(this.repository);

  @override
  Future<Either<Fail, Student>> execute(void params) async {
    return await repository.getStudentPanelProfile();
  }
}
