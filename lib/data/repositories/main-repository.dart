import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuRepository {
  final FirebaseFirestore _firestore;

  MenuRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _menuCollection =>
      _firestore.collection('menuItems');

  Stream<List<MenuItem>> watchMenuItems() {
    return _menuCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MenuItem.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addMenuItem(MenuItem item) async {
    await _menuCollection.add(item.toFirestore());
  }
}