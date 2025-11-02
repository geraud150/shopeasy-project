import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopeasy_flutter/services/api_service.dart';
import 'package:shopeasy_flutter/models/cart.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _placeOrder() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final cart = Provider.of<Cart>(context, listen: false);
      final cartItems = cart.items.values.toList();

      // Convertir les éléments du panier en données pour l'API
      final orderData = {
        'items': cartItems
            .map((item) => {
                  'productId': item.id,
                  'quantity': item.quantity,
                })
            .toList(),
        'totalAmount': cart.totalAmount,
      };

      await _apiService.post('orders', orderData);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Order Placed!'),
          content: const Text('Your order has been successfully placed.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                cart.clear(); // Vider le panier après la commande
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Code de nettoyage sans return
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(cartItems[i].title),
                  trailing: Text(
                    '${cartItems[i].quantity} x \$${cartItems[i].price.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Confirm Order'),
              ),
          ],
        ),
      ),
    );
  }
}
