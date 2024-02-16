class Order {
  final int? id;
  final String userId;
  final double totalPrice;
  final String deliveryAddress;
  final double deliveryFee;
  final String dateTime;
  final bool isPickup;

  Order({
        this.id,
        required this.userId,
        required this.totalPrice,
        required this.deliveryAddress,
        required this.deliveryFee,
        required this.dateTime,
        required this.isPickup});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'totalPrice': totalPrice,
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'dateTime': dateTime,
      'isPickup': isPickup ? 1 : 0,
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int?,
      userId: map['userId'],
      totalPrice: map['totalPrice'],
      deliveryAddress: map['deliveryAddress'],
      deliveryFee: map['deliveryFee'],
      dateTime: map['dateTime'],
      isPickup: map['isPickup'] == 1,
    );
  }
}
