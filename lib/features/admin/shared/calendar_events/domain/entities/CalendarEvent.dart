class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String category;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
  });

  @override
  String toString() => title;
}