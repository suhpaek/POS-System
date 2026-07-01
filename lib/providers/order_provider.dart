import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/order_repository.dart';
import '../data/models/order.dart' as models;
import 'menu_provider.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return OrderRepository(firestore);
});

final activeOrdersProvider = StreamProvider<List<models.Order>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchActiveOrders();
});

final tableOrderProvider = StreamProvider.family<models.Order?, int>((ref, tableNumber) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchOrderForTable(tableNumber);
});