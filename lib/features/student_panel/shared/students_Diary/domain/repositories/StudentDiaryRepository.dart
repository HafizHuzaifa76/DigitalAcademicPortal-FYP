import 'package:dartz/dartz.dart';

import '../../domain/entities/Note.dart';

abstract class StudentDiaryRepository {
  Future<Either<Fail, List<Note>>> getNotes(String deptName, String studentRollNo);
  Future<Either<Fail, void>> createNote(String deptName, String studentRollNo, Note note);
  Future<Either<Fail, void>> editNote(String deptName, String studentRollNo, Note note);
  Future<Either<Fail, void>> removeNote(String deptName, String studentRollNo, Note note);
}