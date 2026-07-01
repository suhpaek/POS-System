class RestaurantTable {
  final String id;
  final int number;
  final String status;

  RestaurantTable({
    required this.id,
    required this.number,
    this.status = 'free',
  });

  factory RestaurantTable.fromFirestore(String id, Map<String, dynamic> data) {
    return RestaurantTable(
      id: id,
      number: data['number'] as int,
      status: data['status'] as String? ?? 'free',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'number': number,
      'status': status,
    };
  }
}