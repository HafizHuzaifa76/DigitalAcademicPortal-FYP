import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentUploadedFileModel.dart';
import '../../domain/entities/UploadedFile.dart';

abstract class StudentUploadedFileRemoteDataSource {
  Future<List<StudentUploadedFileModel>> getFiles(String dept, String semester,
      String course, String section, FileType type);
}

class StudentUploadedFileRemoteDataSourceImpl
    implements StudentUploadedFileRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudentUploadedFileModel>> getFiles(String dept, String semester,
      String course, String section, FileType type) async {
    final snapshot = await firestore
        .collection('departments')
        .doc(dept)
        .collection('semesters')
        .doc(semester)
        .collection('courses')
        .doc(course)
        .collection('sections')
        .doc(section)
        .collection('uploaded_files')
        .where('type', isEqualTo: _fileTypeToString(type))
        .get();

    final files = snapshot.docs
        .map((doc) => StudentUploadedFileModel.fromMap(doc.data(), doc.id))
        .toList();

    files.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    return files;
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
