
import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';

abstract class StudentNoticeRepository{

  Future<Either<Fail, List<MainNotice>>> showAllNotices();

}