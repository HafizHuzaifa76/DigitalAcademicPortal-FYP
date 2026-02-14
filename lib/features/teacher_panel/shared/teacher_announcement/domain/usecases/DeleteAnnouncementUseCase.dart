import 'package:dartz/dartz.dart';
import '../repositories/AnnouncementRepository.dart';
import '../../../../../../core/usecases/UseCase.dart';

class DeleteAnnouncementUseCase implements UseCase<void, String> {
  final AnnouncementRepository repository;

  DeleteAnnouncementUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(String announcementId) async {
    return await repository.deleteAnnouncement(announcementId);
  }
}
