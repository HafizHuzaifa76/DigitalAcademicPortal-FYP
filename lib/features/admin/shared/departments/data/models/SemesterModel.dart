
import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Semester.dart';

class SemesterModel extends Semester{
  SemesterModel({required super.semesterName, required super.sectionLimit, required super.totalCourses, required super.totalStudents, required super.totalTeachers});

  factory SemesterModel.fromSemester(Semester semester){
    return SemesterModel(
      semesterName: semester.semesterName,
      sectionLimit: semester.sectionLimit,
      totalCourses: semester.totalCourses,
      totalStudents: semester.totalStudents,
      totalTeachers: semester.totalTeachers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterName': semesterName,
      'sectionLimit': sectionLimit,
      'totalCourses': totalCourses,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
    };
  }

  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      semesterName: map['semesterName'] as String,
      sectionLimit: map['sectionLimit'] as int,
      totalCourses: map['totalCourses'] as int,
      totalStudents: map['totalStudents'] as int,
      totalTeachers: map['totalTeachers'] as int,
    );
  }
}