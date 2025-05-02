
import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../../domain/repositories/NoticeBoardRepository.dart';
import '../datasources/NoticeBoardRemoteDataSource.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';

class NoticeRepositoryImpl implements NoticeRepository{
  final NoticeRemoteDataSource noticeRemoteDataSource;

  NoticeRepositoryImpl({required this.noticeRemoteDataSource});


  @override
  Future<Either<Fail, MainNotice>> addNotice(MainNotice notice) async {
    try {
      return Right(await noticeRemoteDataSource.addNotice(NoticeModel.fromNotice(notice)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteNotice(MainNotice notice) async {
    try {
      return Right(await noticeRemoteDataSource.deleteNotice('id'));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, MainNotice>> editNotice(MainNotice notice) async {
    try {
      return Right(await noticeRemoteDataSource.editNotice(NoticeModel.fromNotice(notice)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<MainNotice>>> showAllNotices() async {
    try {
      return Right(await noticeRemoteDataSource.allNotices());
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}