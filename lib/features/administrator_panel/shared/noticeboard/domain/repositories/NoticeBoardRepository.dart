
import 'package:dartz/dartz.dart';
import '../entities/MainNotice.dart';

abstract class NoticeRepository{

  Future<Either<Fail, MainNotice>> addNotice(MainNotice notice);
  Future<Either<Fail, MainNotice>> editNotice(MainNotice notice);
  Future<Either<Fail, void>> deleteNotice(MainNotice notice);
  Future<Either<Fail, List<MainNotice>>> showAllNotices();

}