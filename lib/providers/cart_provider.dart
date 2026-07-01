import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/menu_item.dart';
import '../data/models/order.dart' as models;

class CartItem {
  final MenuItem menuItem;
  final int quantity;

  CartItem({required this.menuItem, this.quantity = 1});

  CartItem coopyWith({int? quantity}) {
    return CartItem(
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => menuItem.price * quantity;
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(MenuItem menuItem) {
    final existingItemIndex = state.indexWhere((item) => item.menuItem.id == menuItem.id);
    if (existingItemIndex != -1) {
      final existingItem = state[existingItemIndex];
      state = [
        ...state.sublist(0, existingItemIndex),
        existingItem.coopyWith(quantity: existingItem.quantity + 1),
        ...state.sublist(existingItemIndex + 1),
      ];
    } else {
      state = [...state, CartItem(menuItem: menuItem)];
    }
  }

  void removeItem(MenuItem menuItem) {
    state = state.where((item) => item.menuItem.id != menuItem.id).toList();
  }

  void clear() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0, (sum, item) => sum + item.totalPrice);

    
  }
  
  List<models.OrderItem> toOrderItems() {
      return state.map((cartItem) {
        return models.OrderItem(
          menuItemid: cartItem.menuItem.id,
          name: cartItem.menuItem.name,
          quantity: cartItem.quantity,
          priceAtOrder: cartItem.menuItem.price,
        );
      }).toList();
    }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new,);