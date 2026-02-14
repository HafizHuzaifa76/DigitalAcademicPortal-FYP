import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';

class SemesterModel extends Semester {
  SemesterModel(
      {required super.semesterName,
      required super.sectionLimit,
      required super.totalCourses,
      required super.numOfCourses,
      required super.numOfStudents,
      required super.numOfSections,
      required super.numOfElectiveCourses});

  factory SemesterModel.fromSemester(Semester semester) {
    return SemesterModel(
      semesterName: semester.semesterName,
      sectionLimit: semester.sectionLimit,
      totalCourses: semester.totalCourses,
      numOfCourses: semester.numOfCourses,
      numOfElectiveCourses: semester.numOfElectiveCourses,
      numOfStudents: semester.numOfStudents,
      numOfSections: semester.numOfSections,
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
      'numOfSections': numOfSections,
    };
  }

  factory SemesterModel.fromMap(
      Map<String, dynamic> map, int sectionCount, int studentCount) {
    return SemesterModel(
      semesterName: map['semesterName'] as String,
      sectionLimit: map['sectionLimit'].toInt(),
      totalCourses: map['totalCourses'].toInt(),
      numOfCourses: map['numOfCourses'].toInt(),
      numOfElectiveCourses: map['numOfElectiveCourses'].toInt(),
      numOfStudents: studentCount,
      numOfSections: sectionCount,
    );
  }
}
