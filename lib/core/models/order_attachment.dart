class OrderAttachment {
  OrderAttachment({
    this.id,
    required this.orderId,
    required this.filePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String? id;
  final String orderId;
  final String filePath;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderAttachment.fromMap(Map<String, dynamic> map) {
    return OrderAttachment(
      id: map['id'],
      orderId: map['orderId'],
      filePath: map['filePath'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
