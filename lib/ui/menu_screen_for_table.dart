import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/menu_provider.dart';
import '../data/models/order.dart';
import 'cart_screen.dart';

class MenuScreenForTable extends ConsumerWidget {
  final int tableNumber;

  const MenuScreenForTable({super.key, required this.tableNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuItemsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu - Table $tableNumber'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.length}'),
              isLabelVisible: cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(tableNumber: tableNumber),
                ),
              );
            },
          ),
        ],
      ),
      body: menuAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Menu is empty'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.category),
                trailing: Text('\$${item.price.toStringAsFixed(0)}'),
                onTap: () {
                  ref.read(cartProvider.notifier).addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}