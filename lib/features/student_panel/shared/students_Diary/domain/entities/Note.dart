class Note {
  final String id;
  final String title;
  final String content;
  final bool isCompleted;
  final DateTime dateTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isCompleted = false,
    required this.dateTime,
  });
}
