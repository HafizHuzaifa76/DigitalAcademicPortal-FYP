import 'package:dartz/dartz.dart';
import '../entities/Announcement.dart';
import '../repositories/AnnouncementRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class CreateAnnouncementUseCase
    implements UseCase<void, CreateAnnouncementParams> {
  final AnnouncementRepository repository;

  CreateAnnouncementUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(CreateAnnouncementParams params) async {
    return await repository.createAnnouncement(
        params.course, params.announcement);
  }
}

class CreateAnnouncementParams {
  final TeacherCourse course;
  final Announcement announcement;

  CreateAnnouncementParams({
    required this.course,
    required this.announcement,
  });
}
