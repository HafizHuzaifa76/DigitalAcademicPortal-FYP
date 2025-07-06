import 'package:dartz/dartz.dart';
import '../entities/Announcement.dart';
import '../repositories/AnnouncementRepository.dart';
import '../../../../../../core/usecases/UseCase.dart';

class UpdateAnnouncementUseCase
    implements UseCase<void, UpdateAnnouncementParams> {
  final AnnouncementRepository repository;

  UpdateAnnouncementUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(UpdateAnnouncementParams params) async {
    return await repository.updateAnnouncement(
        params.announcementId, params.announcement);
  }
}

class UpdateAnnouncementParams {
  final String announcementId;
  final Announcement announcement;

  UpdateAnnouncementParams({
    required this.announcementId,
    required this.announcement,
  });
}
