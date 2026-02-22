class StockMovement {
  final int id;
  final String type; // 'in' ou 'out'
  final int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StockMovement({
    required this.id,
    required this.type,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
