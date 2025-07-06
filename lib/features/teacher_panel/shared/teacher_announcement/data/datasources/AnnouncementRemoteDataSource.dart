import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/AnnouncementModel.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements(TeacherCourse course);
  Future<void> createAnnouncement(
      TeacherCourse course, AnnouncementModel announcement);
  Future<void> updateAnnouncement(
      String announcementId, AnnouncementModel announcement);
  Future<void> deleteAnnouncement(String announcementId);
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<AnnouncementModel>> getAnnouncements(TeacherCourse course) async {
    final snapshot = await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('announcements')
        .orderBy('dateTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createAnnouncement(
      TeacherCourse course, AnnouncementModel announcement) async {
    await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('announcements')
        .add(announcement.toMap());
  }

  @override
  Future<void> updateAnnouncement(
      String announcementId, AnnouncementModel announcement) async {
    // Find the announcement document and update it
    final announcementQuery = await firestore
        .collectionGroup('announcements')
        .where(FieldPath.documentId, isEqualTo: announcementId)
        .get();

    if (announcementQuery.docs.isNotEmpty) {
      final docRef = announcementQuery.docs.first.reference;
      await docRef.update(announcement.toMap());
    }
  }

  @override
  Future<void> deleteAnnouncement(String announcementId) async {
    // Find the announcement document and delete it
    final announcementQuery = await firestore
        .collectionGroup('announcements')
        .where(FieldPath.documentId, isEqualTo: announcementId)
        .get();

    if (announcementQuery.docs.isNotEmpty) {
      final docRef = announcementQuery.docs.first.reference;
      await docRef.delete();
    }
  }
}
