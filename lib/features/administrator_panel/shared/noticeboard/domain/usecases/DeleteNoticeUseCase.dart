import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../repositories/NoticeBoardRepository.dart';

class DeleteNoticeUseCase implements UseCase<void, MainNotice> {
  final NoticeBoardRepository repository;

  DeleteNoticeUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(MainNotice notice) async {
    return await repository.deleteNotice(notice);
  }
}
