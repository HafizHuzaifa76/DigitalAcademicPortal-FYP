import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentNoticeBoardRepository.dart';

class DeleteDepartmentNoticeUseCase
    implements UseCase<void, Map<String, dynamic>> {
  final DepartmentNoticeBoardRepository repository;
  DeleteDepartmentNoticeUseCase(this.repository);
  @override
  Future<Either<Fail, void>> execute(Map<String, dynamic> params) async {
    return await repository.deleteDepartmentNotice(
        params['department'], params['notice']);
  }
}
