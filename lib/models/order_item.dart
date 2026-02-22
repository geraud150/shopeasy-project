class OrderItem {
  final int id;
  final int quantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num? ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
