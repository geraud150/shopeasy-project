class Review {
  final int id;
  final int productId;
  final int userId;
  final String comment;
  final int rating;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.comment,
    required this.rating,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      userId: json['userId'] ?? 0,
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
