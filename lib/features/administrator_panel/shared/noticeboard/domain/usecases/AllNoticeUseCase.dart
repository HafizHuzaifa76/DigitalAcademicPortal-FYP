import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../repositories/NoticeBoardRepository.dart';

class AllNoticesUseCase implements UseCase<List<MainNotice>, void>{
  final NoticeRepository repository;

  AllNoticesUseCase(this.repository);

  @override
  Future<Either<Fail, List<MainNotice>>> execute(void params) async {
    return await repository.showAllNotices();
  }
}