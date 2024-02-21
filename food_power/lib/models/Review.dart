class Review {
  final int? id;
  final String userId;
  final int orderId;
  final String photoPath;
  final String reviewText;

  Review({
    this.id,
    required this.userId,
    required this.orderId,
    required this.photoPath,
    required this.reviewText,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'orderId': orderId,
      'photoPath': photoPath,
      'reviewText': reviewText,
    };
  }

  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int?,
      userId: map['userId'],
      orderId: map['orderId'],
      photoPath: map['photoPath'],
      reviewText: map['reviewText'],
    );
  }
}