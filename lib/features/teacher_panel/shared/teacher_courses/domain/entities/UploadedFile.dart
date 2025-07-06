enum FileType {
  resource,
  lectureSlide,
  syllabus,
}

class UploadedFile {
  final String id;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final DateTime uploadDate;
  final FileType type;
  final String courseId;
  final String courseName;
  final String courseSection;

  UploadedFile({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.uploadDate,
    required this.type,
    required this.courseId,
    required this.courseName,
    required this.courseSection,
  });
}
