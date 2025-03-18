import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/MainNotice.dart';
import '../repositories/NoticeBoardRepository.dart';

class AddNoticeUseCase implements UseCase<MainNotice, MainNotice>{
  final NoticeRepository repository;

  AddNoticeUseCase(this.repository);

  @override
  Future<Either<Fail, MainNotice>> execute(MainNotice notice) async {
    return await repository.addNotice(notice);
  }
}