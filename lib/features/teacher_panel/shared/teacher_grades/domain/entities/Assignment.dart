class Assignment {
  final String id;
  final String courseId;
  final String title;
  final String type; // Assignment, Quiz, Presentation, etc.
  final double totalMarks;
  final String date;
  final String? edited;
  final String semester;
  final String? instructions;
  final bool isPublished;
  final String dueDate;

  Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.type,
    required this.totalMarks,
    required this.date,
    this.edited,
    required this.semester,
    this.instructions,
    required this.isPublished,
    required this.dueDate,
  });

  // Create a new assignment with default values
  factory Assignment.create({
    required String courseId,
    required String title,
    required String type,
    required double totalMarks,
  }) {
    return Assignment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: courseId,
      title: title,
      type: type,
      totalMarks: totalMarks,
      date: DateTime.now().toString().split(' ')[0],
      semester: 'Current', // Can be updated later
      isPublished: true,
      dueDate: DateTime.now().add(const Duration(days: 7)).toString().split(' ')[0],
    );
  }

  // Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'type': type,
      'totalMarks': totalMarks,
      'date': date,
      'edited': edited,
      'semester': semester,
      'instructions': instructions,
      'isPublished': isPublished,
      'dueDate': dueDate,
    };
  }

  // Create from a map from database
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      totalMarks: map['totalMarks']?.toDouble() ?? 0.0,
      date: map['date'] ?? '',
      edited: map['edited'],
      semester: map['semester'] ?? '',
      instructions: map['instructions'],
      isPublished: map['isPublished'] ?? false,
      dueDate: map['dueDate'] ?? '',
    );
  }

  // Create a copy with updated values
  Assignment copyWith({
    String? id,
    String? courseId,
    String? title,
    String? type,
    double? totalMarks,
    String? date,
    String? edited,
    String? semester,
    String? instructions,
    bool? isPublished,
    String? dueDate,
  }) {
    return Assignment(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      type: type ?? this.type,
      totalMarks: totalMarks ?? this.totalMarks,
      date: date ?? this.date,
      edited: edited ?? this.edited,
      semester: semester ?? this.semester,
      instructions: instructions ?? this.instructions,
      isPublished: isPublished ?? this.isPublished,
      dueDate: dueDate ?? this.dueDate,
    );
  }
} 