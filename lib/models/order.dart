import 'order_item.dart';
class Order {
  final int id;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var items = <OrderItem>[];
    if (json['OrderItems'] != null) {
      json['OrderItems'].forEach((v) {
        items.add(OrderItem.fromJson(v));
      });
    }
    return Order(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      totalAmount: (json['totalAmount'] as num? ?? 0).toDouble(),
      items: items,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
