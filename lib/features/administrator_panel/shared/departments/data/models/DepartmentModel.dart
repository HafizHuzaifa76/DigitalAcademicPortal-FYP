import '../../domain/entities/Department.dart';

class DepartmentModel extends Department {
  DepartmentModel(
      {required super.departmentID,
      required super.totalSemesters,
      required super.totalStudents,
      required super.totalTeachers,
      required super.departmentName,
      required super.departmentCode,
      required super.headOfDepartment,
      required super.contactPhone,
      required super.totalCourses,
      required super.sectionLength});

  factory DepartmentModel.fromDepartment(Department department) {
    return DepartmentModel(
      departmentID: department.departmentID,
      totalSemesters: department.totalSemesters,
      totalStudents: department.totalStudents,
      totalTeachers: department.totalTeachers,
      totalCourses: department.totalCourses,
      departmentName: department.departmentName,
      departmentCode: department.departmentCode,
      headOfDepartment: department.headOfDepartment,
      contactPhone: department.contactPhone,
      sectionLength: department.sectionLength,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'departmentID': departmentID,
      'totalSemesters': totalSemesters,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
      'totalCourses': totalCourses,
      'departmentName': departmentName,
      'departmentCode': departmentCode,
      'headOfDepartment': headOfDepartment,
      'contactPhone': contactPhone,
      'sectionLength': sectionLength,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map, String docID,
      int studentCount, int teacherCount) {
    print(docID);
    return DepartmentModel(
      departmentID: map['departmentID'].toInt(),
      totalSemesters: map['totalSemesters'].toInt(),
      totalStudents: studentCount,
      totalTeachers: teacherCount,
      totalCourses: map['totalCourses'].toInt(),
      sectionLength: map['sectionLength'].toInt(),
      departmentName: docID,
      departmentCode: map['departmentCode'] as String,
      headOfDepartment: map['headOfDepartment'] as String,
      contactPhone: map['contactPhone'] as String,
    );
  }
}
