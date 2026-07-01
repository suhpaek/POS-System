import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../data/models/order.dart' as models;

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(activeOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No active orders'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final models.Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Table ${order.tableNumber}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            ...order.items.map(
              (item) => Text('${item.quantity}x ${item.name}'),
            ),
            const SizedBox(height: 12),
            _ActionButton(order: order),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'new':
        color = Colors.orange;
        break;
      case 'in_kitchen':
        color = Colors.blue;
        break;
      case 'ready':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}

class _ActionButton extends ConsumerWidget {
  final models.Order order;

  const _ActionButton({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(orderRepositoryProvider);

    if (order.status == 'new') {
      return ElevatedButton(
        onPressed: () => repository.updateOrderStatus(order.id, 'in_kitchen'),
        child: const Text('Start cooking'),
      );
    } else if (order.status == 'in_kitchen') {
      return ElevatedButton(
        onPressed: () => repository.updateOrderStatus(order.id, 'ready'),
        child: const Text('Mark ready'),
      );
    } else if (order.status == 'ready') {
      return ElevatedButton(
        onPressed: () => repository.updateOrderStatus(order.id, 'paid'),
        child: const Text('Mark paid'),
      );
    }
    return const SizedBox.shrink();
  }
}