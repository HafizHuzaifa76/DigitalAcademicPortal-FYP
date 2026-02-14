import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../../../../../../shared/domain/entities/Teacher.dart';
import '../../../teachers/domain/usecases/DeptTeacherUseCase.dart';

class GetTimeTableTeachersUseCase implements UseCase<List<Teacher>, String>{
  final DeptTeachersUseCase useCase;

  GetTimeTableTeachersUseCase(this.useCase);

  @override
  Future<Either<Fail, List<Teacher>>> execute(String deptName) async {
    return await useCase.execute(deptName);
  }
}