class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final int quantityInStock;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantityInStock,
    required this.imageUrl,
  });

  // This is a factory constructor that creates a Product from a JSON object.
  // It allows us to easily convert the data we get from the API into a Product object.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      quantityInStock: json['quantityInStock'],
      imageUrl: json['imageUrl'],
    );
  }
}