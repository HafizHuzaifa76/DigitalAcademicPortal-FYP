
class MainNotice {
  final String id;
  final String title;
  final String description;
  final String? department;
  final DateTime datePosted;
  final String? imageUrl;

  MainNotice({
    required this.id,
    required this.title,
    required this.description,
    required this.datePosted,
    this.department,
    this.imageUrl,
  });

}
