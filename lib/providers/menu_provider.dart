import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/main-repository.dart';
import '../data/models/menu_item.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return MenuRepository(firestore);
});

final menuItemsProvider = StreamProvider<List<MenuItem>>((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.watchMenuItems();
});