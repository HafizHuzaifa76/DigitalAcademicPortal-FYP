import 'package:dartz/dartz.dart';
import '../entities/Announcement.dart';
import '../repositories/AnnouncementRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class GetAnnouncementsUseCase
    implements UseCase<List<Announcement>, TeacherCourse> {
  final AnnouncementRepository repository;

  GetAnnouncementsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Announcement>>> execute(TeacherCourse course) async {
    return await repository.getAnnouncements(course);
  }
}
