


import '../../domain/entities/Department.dart';

class DepartmentModel extends Department{
  DepartmentModel({required super.departmentID, required super.totalSemesters, required super.totalStudents, required super.totalTeachers, required super.departmentName, required super.departmentCode, required super.headOfDepartment, required super.contactPhone});

  factory DepartmentModel.fromDepartment(Department department){
    return DepartmentModel(
      departmentID: department.departmentID,
      totalSemesters: department.totalSemesters,
      totalStudents: department.totalStudents,
      totalTeachers: department.totalTeachers,
      departmentName: department.departmentName,
      departmentCode: department.departmentCode,
      headOfDepartment: department.headOfDepartment,
      contactPhone: department.contactPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'departmentID': departmentID,
      'totalSemesters': totalSemesters,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
      'departmentName': departmentName,
      'departmentCode': departmentCode,
      'headOfDepartment': headOfDepartment,
      'contactPhone': contactPhone,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      departmentID: map['departmentID'] as int,
      totalSemesters: map['totalSemesters'] as int,
      totalStudents: map['totalStudents'] as int,
      totalTeachers: map['totalTeachers'] as int,
      departmentName: map['departmentName'] as String,
      departmentCode: map['departmentCode'] as String,
      headOfDepartment: map['headOfDepartment'] as String,
      contactPhone: map['contactPhone'] as String,
    );
  }
}