import 'package:flutter/material.dart';
import 'package:shopeasy_flutter/models/order.dart';
import 'package:shopeasy_flutter/services/api_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();

  Future<List<Order>> _fetchOrders() async {
    final data = (await _apiService.get('orders'))['orders'] as List;
    return data.map((item) => Order.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune commande trouvée'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ExpansionTile(
                title: Text('Commande #${order.id} - ${order.status}'),
                subtitle:
                    Text('Total: \\${order.totalAmount.toStringAsFixed(2)}'),
                children: order.items
                    .map((item) => ListTile(
                          title: Text('Produit: ${item.id}'),
                          subtitle: Text('Quantité: ${item.quantity}'),
                          trailing:
                              Text('Prix: \\${item.price.toStringAsFixed(2)}'),
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
