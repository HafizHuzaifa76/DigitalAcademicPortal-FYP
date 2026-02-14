import 'dart:async';
import '../entities/UploadedFile.dart';

abstract class StudentUploadedFileRepository {
  Future<List<UploadedFile>> getFiles(String dept, String semester, String course, String section, FileType type);
}
