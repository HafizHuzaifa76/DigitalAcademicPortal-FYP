import 'package:dartz/dartz.dart';
import '../entities/Announcement.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

abstract class AnnouncementRepository {
  Future<Either<Fail, List<Announcement>>> getAnnouncements(
      TeacherCourse course);
  Future<Either<Fail, void>> createAnnouncement(
      TeacherCourse course, Announcement announcement);
  Future<Either<Fail, void>> updateAnnouncement(
      String announcementId, Announcement announcement);
  Future<Either<Fail, void>> deleteAnnouncement(String announcementId);
}
