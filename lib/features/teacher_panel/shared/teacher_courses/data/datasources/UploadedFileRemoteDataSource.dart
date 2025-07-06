import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/UploadedFileModel.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../domain/entities/UploadedFile.dart';

abstract class UploadedFileRemoteDataSource {
  Future<List<UploadedFileModel>> getFiles(TeacherCourse course, FileType type);
  Future<void> uploadFile(TeacherCourse course, UploadedFileModel file);
  Future<void> deleteFile(TeacherCourse course, String fileId);
}

class UploadedFileRemoteDataSourceImpl implements UploadedFileRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<UploadedFileModel>> getFiles(
      TeacherCourse course, FileType type) async {
    final snapshot = await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('uploaded_files')
        .where('type', isEqualTo: _fileTypeToString(type))
        .get();

    final files = snapshot.docs
        .map((doc) => UploadedFileModel.fromMap(doc.data(), doc.id))
        .toList();

    // Sort in memory instead of using Firestore ordering
    files.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));

    return files;
  }

  @override
  Future<void> uploadFile(TeacherCourse course, UploadedFileModel file) async {
    await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('uploaded_files')
        .add(file.toMap());
  }

  @override
  Future<void> deleteFile(TeacherCourse course, String fileId) async {
    await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('uploaded_files')
        .doc(fileId)
        .delete();
  }

  String _fileTypeToString(FileType type) {
    switch (type) {
      case FileType.lectureSlide:
        return 'lectureSlide';
      case FileType.syllabus:
        return 'syllabus';
      case FileType.resource:
      default:
        return 'resource';
    }
  }
}
