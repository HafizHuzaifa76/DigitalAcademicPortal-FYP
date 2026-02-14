import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';

abstract class DepartmentNoticeBoardRepository {
  Future<Either<Fail, MainNotice>> addDepartmentNotice(
      String department, MainNotice notice);
  Future<Either<Fail, MainNotice>> editDepartmentNotice(
      String department, MainNotice notice);
  Future<Either<Fail, void>> deleteDepartmentNotice(
      String department, MainNotice notice);
  Future<Either<Fail, List<MainNotice>>> showAllDepartmentNotices(
      String department);
}
