import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../repositories/DepartmentNoticeBoardRepository.dart';

class EditDepartmentNoticeUseCase
    implements UseCase<MainNotice, Map<String, dynamic>> {
  final DepartmentNoticeBoardRepository repository;
  EditDepartmentNoticeUseCase(this.repository);
  @override
  Future<Either<Fail, MainNotice>> execute(Map<String, dynamic> params) async {
    return await repository.editDepartmentNotice(
        params['department'], params['notice']);
  }
}
