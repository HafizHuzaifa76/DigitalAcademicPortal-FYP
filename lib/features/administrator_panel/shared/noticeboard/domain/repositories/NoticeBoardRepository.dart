import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';

abstract class NoticeBoardRepository {
  Future<Either<Fail, MainNotice>> addNotice(MainNotice notice);
  Future<Either<Fail, MainNotice>> editNotice(MainNotice notice);
  Future<Either<Fail, void>> deleteNotice(MainNotice notice);
  Future<Either<Fail, List<MainNotice>>> showAllNotices();
}
