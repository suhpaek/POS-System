import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../data/models/order.dart' as models;

class CartScreen extends ConsumerWidget {
  final int tableNumber;

  const CartScreen({super.key, required this.tableNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Table $tableNumber — Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];
                return ListTile(
                  title: Text(cartItem.menuItem.name),
                  subtitle: Text('x${cartItem.quantity}'),
                  trailing: Text(
                    '\$${cartItem.totalPrice.toStringAsFixed(0)}',
                  ),
                  onLongPress: () {
                    cartNotifier.removeItem(cartItem.menuItem);
                  },
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${cartNotifier.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () async {
                          final repository = ref.read(orderRepositoryProvider);
                          final order = models.Order(
                            id: '',
                            tableNumber: tableNumber,
                            items: cartNotifier.toOrderItems(),
                            status: 'new',
                          );
                          await repository.createOrder(order);
                          cartNotifier.clear();

                          if (context.mounted) {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order sent to kitchen!'),
                              ),
                            );
                          }
                        },
                  child: const Text('Send to kitchen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}