class TeacherGrade {
  final String id;
  final String courseId;
  final String courseName;
  final String sectionClass;
  final String studentId;
  final String studentName;
  final double obtainedMarks;
  final double totalMarks;
  final String category; // Assignment, Quiz, Mid, etc.
  final String title;
  final String date;
  final String? edited;
  final String semester;
  final String? remarks;
  final bool isSubmitted;

  TeacherGrade({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.sectionClass,
    required this.studentId,
    required this.studentName,
    required this.obtainedMarks,
    required this.totalMarks,
    required this.category,
    required this.title,
    required this.date,
    this.edited,
    required this.semester,
    this.remarks,
    required this.isSubmitted,
  });

  // Create a grade object with default values
  factory TeacherGrade.initial({
    required String courseId,
    required String courseName,
    required String sectionClass,
    required String studentId,
    required String studentName,
    required double totalMarks,
    required String category,
    required String title,
  }) {
    return TeacherGrade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: courseId,
      courseName: courseName,
      sectionClass: sectionClass,
      studentId: studentId,
      studentName: studentName,
      obtainedMarks: 0,
      totalMarks: totalMarks,
      category: category,
      title: title,
      date: DateTime.now().toString().split(' ')[0],
      semester: 'Current', // Can be updated later
      isSubmitted: false,
    );
  }

  // Create a copy of the grade with updated values
  TeacherGrade copyWith({
    String? id,
    String? courseId,
    String? courseName,
    String? sectionClass,
    String? studentId,
    String? studentName,
    double? obtainedMarks,
    double? totalMarks,
    String? category,
    String? title,
    String? date,
    String? edited,
    String? semester,
    String? remarks,
    bool? isSubmitted,
  }) {
    return TeacherGrade(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      sectionClass: sectionClass ?? this.sectionClass,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      obtainedMarks: obtainedMarks ?? this.obtainedMarks,
      totalMarks: totalMarks ?? this.totalMarks,
      category: category ?? this.category,
      title: title ?? this.title,
      date: date ?? this.date,
      edited: edited ?? this.edited,
      semester: semester ?? this.semester,
      remarks: remarks ?? this.remarks,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  // Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'courseName': courseName,
      'sectionClass': sectionClass,
      'studentId': studentId,
      'studentName': studentName,
      'obtainedMarks': obtainedMarks,
      'totalMarks': totalMarks,
      'category': category,
      'title': title,
      'date': date,
      'edited': edited,
      'semester': semester,
      'remarks': remarks,
      'isSubmitted': isSubmitted,
    };
  }

  // Create from a map from database
  factory TeacherGrade.fromMap(Map<String, dynamic> map) {
    return TeacherGrade(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      sectionClass: map['sectionClass'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      obtainedMarks: map['obtainedMarks']?.toDouble() ?? 0.0,
      totalMarks: map['totalMarks']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      edited: map['edited'],
      semester: map['semester'] ?? '',
      remarks: map['remarks'],
      isSubmitted: map['isSubmitted'] ?? false,
    );
  }
} 