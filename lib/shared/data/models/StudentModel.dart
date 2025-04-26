
import '../../domain/entities/Student.dart';

class StudentModel extends Student{

  StudentModel({required super.studentRollNo, required super.studentName, required super.fatherName, required super.studentCNIC, required super.studentContactNo, required super.studentEmail, required super.studentGender, required super.studentAddress, required super.studentDepartment, required super.studentSemester, required super.studentSection, required super.studentCGPA, required super.studentShift, required super.studentAcademicYear});


  factory StudentModel.fromStudent(Student student){
    return StudentModel(
        studentRollNo: student.studentRollNo,
        studentName: student.studentName,
        fatherName: student.fatherName,
        studentCNIC: student.studentCNIC,
        studentContactNo: student.studentContactNo,
        studentEmail: student.studentEmail,
        studentGender: student.studentGender,
        studentAddress: student.studentAddress,
        studentDepartment: student.studentDepartment,
        studentSemester: student.studentSemester,
        studentSection: student.studentSection,
        studentCGPA: student.studentCGPA,
        studentShift: student.studentShift,
        studentAcademicYear: student.studentAcademicYear
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentRollNo': studentRollNo,
      'studentName': studentName,
      'fatherName': fatherName,
      'studentCNIC': studentCNIC,
      'studentContactNo': studentContactNo,
      'studentEmail': studentEmail,
      'studentGender': studentGender,
      'studentAddress': studentAddress,
      'studentDepartment': studentDepartment,
      'studentSemester': studentSemester,
      'studentShift': studentShift,
      'studentAcademicYear': studentAcademicYear,
      'studentSection': studentSection,
      'studentCGPA': studentCGPA,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentRollNo: map['studentRollNo'] as String,
      studentName: map['studentName'] as String,
      fatherName: map['fatherName'] as String,
      studentCNIC: map['studentCNIC'] as String,
      studentContactNo: map['studentContactNo'] as String,
      studentEmail: map['studentEmail'] as String,
      studentGender: map['studentGender'] as String,
      studentAddress: map['studentAddress'] as String,
      studentDepartment: map['studentDepartment'] as String,
      studentSemester: map['studentSemester'] as String,
      studentShift: map['studentShift'] as String,
      studentAcademicYear: map['studentAcademicYear'] as String,
      studentSection: map['studentSection'] as String,
      studentCGPA: map['studentCGPA'] as double,
    );
  }
}