import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as models;

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _orderCollection =>
      _firestore.collection('orders');

  Stream<List<models.Order>> watchActiveOrders() {
    return _orderCollection
    .where('status', isNotEqualTo: 'paid')
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        return models.Order.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<models.Order?> watchOrderForTable(int tableNumber) {
    return _orderCollection
        .where('tableNumber', isEqualTo: tableNumber)
        .where('status', isNotEqualTo: 'paid')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final doc = snapshot.docs.first;
      return models.Order.fromFirestore(doc.id, doc.data());
    });
  }

  Future<void> createOrder(models.Order order) async {
    await _orderCollection.add(order.toFirestore());
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _orderCollection.doc(orderId).update({'status': newStatus});
  }
}