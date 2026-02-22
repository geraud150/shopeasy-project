class Category {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  Category({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
