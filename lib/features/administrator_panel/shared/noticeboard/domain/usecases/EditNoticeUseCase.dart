import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/MainNotice.dart';
import '../repositories/NoticeBoardRepository.dart';

class EditNoticeUseCase implements UseCase<MainNotice, MainNotice> {
  final NoticeBoardRepository repository;

  EditNoticeUseCase(this.repository);

  @override
  Future<Either<Fail, MainNotice>> execute(MainNotice notice) async {
    return await repository.editNotice(notice);
  }
}
