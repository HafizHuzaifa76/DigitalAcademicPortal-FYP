import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';

class SemesterModel extends Semester {
  SemesterModel(
      {required super.semesterName,
      required super.sectionLimit,
      required super.totalCourses,
      required super.numOfCourses,
      required super.numOfStudents,
      required super.numOfTeachers,
      required super.numOfElectiveCourses});

  factory SemesterModel.fromSemester(Semester semester) {
    return SemesterModel(
      semesterName: semester.semesterName,
      sectionLimit: semester.sectionLimit,
      totalCourses: semester.totalCourses,
      numOfCourses: semester.numOfCourses,
      numOfElectiveCourses: semester.numOfElectiveCourses,
      numOfStudents: semester.numOfStudents,
      numOfTeachers: semester.numOfTeachers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterName': semesterName,
      'sectionLimit': sectionLimit,
      'totalCourses': totalCourses,
      'numOfCourses': numOfCourses,
      'numOfElectiveCourses': numOfElectiveCourses,
      'numOfStudents': numOfStudents,
      'numOfTeachers': numOfTeachers,
    };
  }

  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      semesterName: map['semesterName'] as String,
      sectionLimit: map['sectionLimit'].toInt(),
      totalCourses: map['totalCourses'].toInt(),
      numOfCourses: map['numOfCourses'].toInt(),
      numOfElectiveCourses: map['numOfElectiveCourses'].toInt(),
      numOfStudents: map['numOfStudents'].toInt(),
      numOfTeachers: map['numOfTeachers'].toInt(),
    );
  }
}
