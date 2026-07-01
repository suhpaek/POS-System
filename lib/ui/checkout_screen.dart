import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../data/models/order.dart' as models;

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(activeOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ordersAsync.when(
        data: (orders) {
          // Only show orders that are ready to be paid (kitchen marked them 'ready')
          final readyOrders =
              orders.where((order) => order.status == 'ready').toList();

          if (readyOrders.isEmpty) {
            return const Center(child: Text('No orders ready for payment'));
          }
          return ListView.builder(
            itemCount: readyOrders.length,
            itemBuilder: (context, index) {
              final order = readyOrders[index];
              return _ReceiptCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ReceiptCard extends ConsumerWidget {
  final models.Order order;

  const _ReceiptCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(orderRepositoryProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Table ${order.tableNumber}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.name}'),
                    Text(
                      '\$${(item.priceAtOrder * item.quantity).toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await repository.updateOrderStatus(order.id, 'paid');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Table ${order.tableNumber} — paid!'),
                      ),
                    );
                  }
                },
                child: const Text('Confirm payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}