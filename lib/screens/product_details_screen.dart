import 'package:flutter/material.dart';
import 'package:shopeasy_flutter/models/product.dart';
import 'package:shopeasy_flutter/models/review.dart';
import 'package:shopeasy_flutter/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shopeasy_flutter/models/cart.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}

class ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<Product> _productFuture;
  late Future<List<Review>> _reviewsFuture;
  final ApiService _apiService = ApiService();
  final _reviewController = TextEditingController();
  int _reviewRating = 5;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProductDetails();
    _reviewsFuture = _fetchReviews(widget.productId);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<Product> _fetchProductDetails() async {
    final data = await _apiService.get('products/${widget.productId}');
    return Product.fromJson(data);
  }

  Future<List<Review>> _fetchReviews(int productId) async {
    final data = await _apiService.get('products/$productId/reviews');
    if (data['reviews'] != null && data['reviews'] is List) {
      return (data['reviews'] as List)
          .map((json) => Review.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<void> _addReview(int productId) async {
    final reviewData = {
      'comment': _reviewController.text,
      'rating': _reviewRating,
    };
    try {
      await _apiService.post('products/$productId/reviews', reviewData);

      // ✅ Vérification mounted après await
      if (!mounted) return;

      setState(() {
        _reviewsFuture = _fetchReviews(productId);
        _reviewController.clear();
        _reviewRating = 5;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review added!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // ✅ Vérification mounted après catch
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image,
                            size: 100, color: Colors.grey),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final cart = Provider.of<Cart>(context, listen: false);
                      cart.addItem(
                        product.id.toString(),
                        product.price,
                        product.title,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                  const SizedBox(height: 24),
                  // Avis clients
                  FutureBuilder<List<Review>>(
                    future: _reviewsFuture,
                    builder: (context, reviewSnapshot) {
                      if (reviewSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (reviewSnapshot.hasError) {
                        return const Text('Erreur lors du chargement des avis');
                      } else if (!reviewSnapshot.hasData ||
                          reviewSnapshot.data!.isEmpty) {
                        return const Text('Aucun avis pour ce produit');
                      }
                      final reviews = reviewSnapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Avis clients',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          ...reviews.map((review) => ListTile(
                                leading: const Icon(Icons.star,
                                    color: Colors.amber),
                                title: Text(review.comment),
                                subtitle: Text('Note: ${review.rating}/5'),
                              )),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Formulaire d'ajout d'avis
                  const Text(
                    'Ajouter un avis',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                        labelText: 'Votre commentaire'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Note: '),
                      DropdownButton<int>(
                        value: _reviewRating,
                        items: List.generate(5, (index) => index + 1)
                            .map((rating) => DropdownMenuItem(
                                  value: rating,
                                  child: Text(rating.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _reviewRating = value ?? 5;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addReview(product.id);
                    },
                    child: const Text('Envoyer l\'avis'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}