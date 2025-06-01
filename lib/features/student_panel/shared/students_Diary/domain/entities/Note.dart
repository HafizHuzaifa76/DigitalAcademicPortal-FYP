class Note {
  final String id;
  final String title;
  final String content;
  final bool isCompleted;
  final String dateTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isCompleted = false,
    required this.dateTime,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isCompleted,
    String? dateTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}