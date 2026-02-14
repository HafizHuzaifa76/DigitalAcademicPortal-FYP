class Grade {
  final String id;
  final String title;
  final int totalMarks;
  final String type;
  final Map<String, dynamic> obtainedMarks;

  const Grade({
    required this.id,
    required this.title,
    required this.type,
    required this.totalMarks,
    this.obtainedMarks = const {},
  });

  // Create a new assignment with default values
  factory Grade.create({
    required String courseId,
    required String title,
    required String type,
    required int totalMarks,
  }) {
    return Grade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      type: type,
      totalMarks: totalMarks.toInt(),
    );
  }

  factory Grade.fromMap(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      totalMarks: json['totalMarks'] as int,
      obtainedMarks: Map<String, dynamic>.from(json['obtainedMarks'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'totalMarks': totalMarks,
      'obtainedMarks': obtainedMarks,
    };
  }

  Grade copyWith({
    String? id,
    String? title,
    String? type,
    int? totalMarks,
    Map<String, dynamic>? obtainedMarks,
  }) {
    return Grade(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      totalMarks: totalMarks ?? this.totalMarks,
      obtainedMarks: obtainedMarks ?? this.obtainedMarks,
    );
  }
}
