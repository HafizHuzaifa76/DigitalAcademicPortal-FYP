class Course {
  final String id;
  final String courseCode;
  final String sectionClass;
  final String teacherName;
  final String teacherId;
  final int studentCount;
  final String semester;
  final String? description;

  Course({
    required this.id,
    required this.courseCode,
    required this.sectionClass,
    required this.teacherName,
    required this.teacherId,
    required this.studentCount,
    required this.semester,
    this.description,
  });

  // Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseCode': courseCode,
      'sectionClass': sectionClass,
      'teacherName': teacherName,
      'teacherId': teacherId,
      'studentCount': studentCount,
      'semester': semester,
      'description': description,
    };
  }

  // Create from a map from database
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] ?? '',
      courseCode: map['courseCode'] ?? '',
      sectionClass: map['sectionClass'] ?? '',
      teacherName: map['teacherName'] ?? '',
      teacherId: map['teacherId'] ?? '',
      studentCount: map['studentCount'] ?? 0,
      semester: map['semester'] ?? '',
      description: map['description'],
    );
  }
} 