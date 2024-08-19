
import '../../domain/entities/Student.dart';

class StudentModel extends Student{

  StudentModel({required super.studentID, required super.studentName, required super.fatherName, required super.studentCNIC, required super.studentContactNo, required super.studentEmail, required super.studentGender, required super.studentAddress, required super.studentDepartment, required super.studentSemester, required super.studentSection, required super.studentCGPA});

  Map<String, dynamic> toMap() {
    return {
      'studentID': studentID,
      'studentName': studentName,
      'fatherName': fatherName,
      'studentCNIC': studentCNIC,
      'studentContactNo': studentContactNo,
      'studentEmail': studentEmail,
      'studentGender': studentGender,
      'studentAddress': studentAddress,
      'studentDepartment': studentDepartment,
      'studentSemester': studentSemester,
      'studentSection': studentSection,
      'studentCGPA': studentCGPA,
    };
  }

  factory StudentModel.fromStudent(Student student){
    return StudentModel(
        studentID: student.studentID,
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
        studentCGPA: student.studentCGPA
    );
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentID: map['studentID'] as String,
      studentName: map['studentName'] as String,
      fatherName: map['fatherName'] as String,
      studentCNIC: map['studentCNIC'] as String,
      studentContactNo: map['studentContactNo'] as String,
      studentEmail: map['studentEmail'] as String,
      studentGender: map['studentGender'] as String,
      studentAddress: map['studentAddress'] as String,
      studentDepartment: map['studentDepartment'] as String,
      studentSemester: map['studentSemester'] as String,
      studentSection: map['studentSection'] as String,
      studentCGPA: map['studentCGPA'] as String,
    );
  }
}