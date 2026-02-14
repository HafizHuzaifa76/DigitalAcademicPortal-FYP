class Note {
  final String id;
  final String title;
  final String content;
  final bool isCompleted;
  final String dateTime;
  final String? priority;
  final String? category;
  final String? dueDate;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isCompleted = false,
    required this.dateTime,
    this.priority,
    this.category,
    this.dueDate,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isCompleted,
    String? dateTime,
    String? priority,
    String? category,
    String? dueDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}