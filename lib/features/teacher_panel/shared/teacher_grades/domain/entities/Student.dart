class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String email;
  final List<String> enrolledCourseIds;
  double? obtainedMarks; // For temporary use in UI
  bool? isSelected; // For temporary use in UI

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.email,
    required this.enrolledCourseIds,
    this.obtainedMarks,
    this.isSelected = false,
  });

  // Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rollNumber': rollNumber,
      'email': email,
      'enrolledCourseIds': enrolledCourseIds,
    };
  }

  // Create from a map from database
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      rollNumber: map['rollNumber'] ?? '',
      email: map['email'] ?? '',
      enrolledCourseIds: List<String>.from(map['enrolledCourseIds'] ?? []),
    );
  }
} 