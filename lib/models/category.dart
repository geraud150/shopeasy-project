class Category {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final int userId;

  Category({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      userId: json['userId'] ?? 0,
    );
  }
}
