import '../../domain/entities/UploadedFile.dart';

class StudentUploadedFileModel extends UploadedFile {
  StudentUploadedFileModel({
    required super.id,
    required super.fileName,
    required super.fileUrl,
    required super.fileSize,
    required super.uploadDate,
    required super.type,
    required super.courseId,
    required super.courseName,
    required super.courseSection,
  });

  factory StudentUploadedFileModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return StudentUploadedFileModel(
      id: documentId,
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      uploadDate: map['uploadDate']?.toDate() ?? DateTime.now(),
      type: _parseFileType(map['type'] ?? 'resource'),
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      courseSection: map['courseSection'] ?? '',
    );
  }

  static FileType _parseFileType(String type) {
    switch (type) {
      case 'lectureSlide':
        return FileType.lectureSlide;
      case 'syllabus':
        return FileType.syllabus;
      case 'resource':
      default:
        return FileType.resource;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'uploadDate': uploadDate,
      'type': _fileTypeToString(type),
      'courseId': courseId,
      'courseName': courseName,
      'courseSection': courseSection,
    };
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
