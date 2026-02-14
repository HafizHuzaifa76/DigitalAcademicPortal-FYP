import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/DepartmentCourse.dart';
import 'package:digital_academic_portal/shared/domain/entities/Teacher.dart';

import '../../features/student_panel/shared/students_Diary/domain/entities/Note.dart';
import '../../shared/domain/entities/SemesterCourse.dart';
import '../../features/administrator_panel/shared/departments/domain/entities/Semester.dart';
import '../../features/administrator_panel/shared/sections/domain/entities/Section.dart';
import '../../shared/domain/entities/Student.dart';
import '../../shared/domain/entities/TimeTable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Fail, Type>> execute(Params params);
}

class NoteParams {
  final String deptName;
  final String studentRollNo;
  Note? note;

  NoteParams({required this.deptName, required this.studentRollNo, required this.note });

}

class CourseParams {
  final String deptName;
  final DepartmentCourse course;

  CourseParams(this.deptName, this.course);
}

class SemesterParams{
  final String deptName;
  final String semester;

  SemesterParams(this.deptName, this.semester);
}

class UpdateSemesterParams{
  final String deptName;
  final Semester semester;

  UpdateSemesterParams(this.deptName, this.semester);
}

class TimeTableParams{
  final String deptName;
  final String semester;
  final List<TimeTableEntry> timeTable;

  TimeTableParams({required this.deptName, required this.semester, required this.timeTable});
}

class SectionParams{
  final String deptName;
  final String semester;
  final Section section;

  SectionParams({required this.deptName, required this.semester, required this.section});
}

class AssignTeachersParams{
  final String deptName;
  final String semester;
  final String section;
  Map<String, dynamic> coursesTeachersMap;

  AssignTeachersParams({required this.deptName, required this.semester, required this.section, required this.coursesTeachersMap});
}

class EditAssignTeachersParams{
  final String deptName;
  final String semester;
  final String section;
  final String courseName;
  final Teacher teacher;

  EditAssignTeachersParams({required this.deptName, required this.semester, required this.section, required this.courseName, required this.teacher});
}

class SectionParams2{
  final String deptName;
  final String semester;
  final String section;

  SectionParams2({required this.deptName, required this.semester, required this.section});
}

class SectionLimitParams{
  final String deptName;
  final String semester;
  final int sectionLimit;

  SectionLimitParams({required this.deptName, required this.semester, required this.sectionLimit});
}



class StudentListParams{
  List<Student> studentList;
  bool isNewStudent;

  StudentListParams(this.studentList, this.isNewStudent);
}

class TwoParams{
  final param1;
  final param2;

  TwoParams(this.param1, this.param2);
}

class ThreeParams{
  final param1;
  final param2;
  final param3;

  const ThreeParams({
    required this.param1,
    required this.param2,
    required this.param3,
  });
}