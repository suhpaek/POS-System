class OrderItem {
  final String menuItemid;
  final String name;
  final int quantity;
  final double priceAtOrder;
  final String status;

  OrderItem({
    required this.menuItemid,
    required this.name,
    required this.quantity,
    required this.priceAtOrder,
    this.status = 'pending',
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      menuItemid: data['menuItemid'] as String,
      name: data['name'] as String,
      quantity: data['quantity'] as int,
      priceAtOrder: (data['priceAtOrder'] as num).toDouble(),
      status: data['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemid': menuItemid,
      'name': name,
      'quantity': quantity,
      'priceAtOrder': priceAtOrder,
      'status': status,
    };
  }
}

class Order {
  final String id;
  final int tableNumber;
  final List<OrderItem> items;
  final String status;

  Order({
    required this.id,
    required this.tableNumber,
    required this.items,
    this.status = 'pending',
  });

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.priceAtOrder * item.quantity));
  }

  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    final itemsList = (data['items'] as List<dynamic>)
        .map((itemData) => OrderItem.fromMap(itemData as Map<String, dynamic>))
        .toList();
        
    return Order(
      id: id,
      tableNumber: data['tableNumber'] as int,
      items: itemsList,
      status: data['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tableNumber': tableNumber,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
    };
  }
}