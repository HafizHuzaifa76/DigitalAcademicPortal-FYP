
import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../../domain/repositories/StudentNoticeBoardRepository.dart';
import '../datasources/StudentNoticeBoardRemoteDataSource.dart';

class StudentNoticeRepositoryImpl implements StudentNoticeRepository{
  final StudentNoticeRemoteDataSource noticeRemoteDataSource;

  StudentNoticeRepositoryImpl({required this.noticeRemoteDataSource});


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