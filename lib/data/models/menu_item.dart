class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool isAvailable;
  

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.isAvailable = true,
  });

  factory MenuItem.fromFirestore(String id, Map<String, dynamic> data) {
    return MenuItem(
      id: id,
      name: data['name'] as String,
      category: data['category'] as String,
      price: (data['price'] as num).toDouble(),
    
      isAvailable: data['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'isAvailable': isAvailable,
    };
  }
}