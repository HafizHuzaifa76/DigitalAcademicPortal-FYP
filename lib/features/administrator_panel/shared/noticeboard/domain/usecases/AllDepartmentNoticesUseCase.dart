import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../repositories/DepartmentNoticeBoardRepository.dart';

class AllDepartmentNoticesUseCase implements UseCase<List<MainNotice>, String> {
  final DepartmentNoticeBoardRepository repository;
  AllDepartmentNoticesUseCase(this.repository);
  @override
  Future<Either<Fail, List<MainNotice>>> execute(String department) async {
    return await repository.showAllDepartmentNotices(department);
  }
}
