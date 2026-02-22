// lib/models/cart.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // Retourne une copie des éléments du panier pour éviter les modifications externes
  Map<String, CartItem> get items {
    return {..._items};
  }

  // Retourne le nombre total d'articles dans le panier
  int get itemCount {
    return _items.length;
  }

  // Retourne le montant total du panier
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Ajoute un article au panier
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  // Met à jour la quantité d'un article dans le panier
  void updateItemQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      if (newQuantity <= 0) {
        removeItem(productId);
      } else {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: newQuantity,
            price: existingCartItem.price,
          ),
        );
        notifyListeners();
      }
    }
  }

  // Vérifie si un article est déjà dans le panier
  bool containsItem(String productId) {
    return _items.containsKey(productId);
  }

  // Retourne la quantité d'un article dans le panier
  int getItemQuantity(String productId) {
    return _items.containsKey(productId) ? _items[productId]!.quantity : 0;
  }

  // Supprime un article du panier
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Vide le panier
  void clear() {
    _items = {};
    notifyListeners();
  }
}
