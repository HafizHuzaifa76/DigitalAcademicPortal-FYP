import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/AssignTeachersUseCase.dart';

class GetAssignedTeachersUseCase
    implements UseCase<Map<String, String?>, SectionParams2> {
  final FetchAssignedTeachersUseCase useCase;

  GetAssignedTeachersUseCase(this.useCase);

  @override
  Future<Either<Fail, Map<String, String?>>> execute(
      SectionParams2 params) async {
    return await useCase.execute(params);
  }
}
