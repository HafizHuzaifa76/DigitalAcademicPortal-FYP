import 'package:dartz/dartz.dart';
import '../../domain/entities/Announcement.dart';
import '../../domain/repositories/AnnouncementRepository.dart';
import '../datasources/AnnouncementRemoteDataSource.dart';
import '../models/AnnouncementModel.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<Announcement>>> getAnnouncements(
      TeacherCourse course) async {
    try {
      final announcements = await remoteDataSource.getAnnouncements(course);
      return Right(announcements);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> createAnnouncement(
      TeacherCourse course, Announcement announcement) async {
    try {
      final announcementModel = AnnouncementModel(
        id: announcement.id,
        title: announcement.title,
        content: announcement.content,
        dateTime: announcement.dateTime,
        isPublished: announcement.isPublished,
        courseId: announcement.courseId,
        courseName: announcement.courseName,
        courseSection: announcement.courseSection,
      );

      await remoteDataSource.createAnnouncement(course, announcementModel);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> updateAnnouncement(
      String announcementId, Announcement announcement) async {
    try {
      final announcementModel = AnnouncementModel(
        id: announcement.id,
        title: announcement.title,
        content: announcement.content,
        dateTime: announcement.dateTime,
        isPublished: announcement.isPublished,
        courseId: announcement.courseId,
        courseName: announcement.courseName,
        courseSection: announcement.courseSection,
      );

      await remoteDataSource.updateAnnouncement(
          announcementId, announcementModel);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> deleteAnnouncement(String announcementId) async {
    try {
      await remoteDataSource.deleteAnnouncement(announcementId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
