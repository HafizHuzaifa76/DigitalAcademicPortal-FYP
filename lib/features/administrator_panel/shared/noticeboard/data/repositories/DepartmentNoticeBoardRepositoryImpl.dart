import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../../domain/repositories/DepartmentNoticeBoardRepository.dart';
import '../datasources/DepartmentNoticeRemoteDataSource.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';

class DepartmentNoticeBoardRepositoryImpl
    implements DepartmentNoticeBoardRepository {
  final DepartmentNoticeRemoteDataSource remoteDataSource;
  DepartmentNoticeBoardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, MainNotice>> addDepartmentNotice(
      String department, MainNotice notice) async {
    try {
      return Right(await remoteDataSource.addDepartmentNotice(
          department, NoticeModel.fromNotice(notice)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1) {
        message = message.substring(startIndex + 1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteDepartmentNotice(
      String department, MainNotice notice) async {
    try {
      return Right(
          await remoteDataSource.deleteDepartmentNotice(department, notice.id));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1) {
        message = message.substring(startIndex + 1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, MainNotice>> editDepartmentNotice(
      String department, MainNotice notice) async {
    try {
      return Right(await remoteDataSource.editDepartmentNotice(
          department, NoticeModel.fromNotice(notice)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1) {
        message = message.substring(startIndex + 2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<MainNotice>>> showAllDepartmentNotices(
      String department) async {
    try {
      return Right(await remoteDataSource.allDepartmentNotices(department));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1) {
        message = message.substring(startIndex + 2);
      }
      return Left(Fail(message));
    }
  }
}
