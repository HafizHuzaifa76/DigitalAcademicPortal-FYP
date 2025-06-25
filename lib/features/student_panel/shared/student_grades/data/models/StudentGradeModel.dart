import '../../domain/entities/StudentGrade.dart';

class StudentGradeModel extends StudentGrade {
  StudentGradeModel({required super.id, required super.title, required super.totalMarks, required super.type, required super.obtainedMarks});
  
  factory StudentGradeModel.fromMap(Map<String, dynamic> json, double obtainedMarks) {
    return StudentGradeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      totalMarks: json['totalMarks'] as int,
      type: json['type'] as String,
      obtainedMarks: obtainedMarks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalMarks': totalMarks,
      'type': type,
      'obtainedMarks': obtainedMarks,
    };
  }
}
