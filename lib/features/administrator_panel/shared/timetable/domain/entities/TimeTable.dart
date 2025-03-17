
class TimetableEntry {
  final String id;
  final String title;
  final String description;
  final DateTime datePosted;
  final String? imageUrl;

  TimetableEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.datePosted,
    this.imageUrl,
  });

}
