class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  final double rating;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'rating': rating,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'] ?? 0,
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? quantity,
    double? rating,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
    );
  }
}
