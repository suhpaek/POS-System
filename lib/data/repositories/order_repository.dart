import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as models;

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  Stream<List<models.Order>> watchActiveOrders() {
    return _ordersCollection
        .where('status', isNotEqualTo: 'paid')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => models.Order.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<models.Order?> watchOrderForTable(int tableNumber) {
    return _ordersCollection
        .where('tableNumber', isEqualTo: tableNumber)
        .where('status', isNotEqualTo: 'paid')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return models.Order.fromFirestore(doc.id, doc.data());
    });
  }

  Future<void> createOrder(models.Order order) async {
    await _ordersCollection.add(order.toFirestore());
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _ordersCollection.doc(orderId).update({'status': newStatus});
  }

  Future<void> markAsPaid(String orderId) async {
    await _ordersCollection.doc(orderId).update({
      'status': 'paid',
      'paidAt': Timestamp.now(),
    });
  }

  Stream<List<models.Order>> watchPaidOrders() {
    return _ordersCollection
        .where('status', isEqualTo: 'paid')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => models.Order.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }
}