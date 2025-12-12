class OrderModel {  // ✅ Changed from Order to OrderModel
  final String id;
  final List<OrderItem> items;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  final String status;

  OrderModel({
    required this.id,
    required this. items,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    items: (json['items'] as List)
        .map((item) => OrderItem.fromJson(item))
        .toList(),
    total: json['total']. toDouble(),
    paymentMethod:  json['paymentMethod'],
    createdAt: DateTime.parse(json['createdAt']),
    status: json['status'] ?? 'pending',
  );
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this. productId,
    required this. productName,
    required this. quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'price': price,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productId: json['productId'],
    productName: json['productName'],
    quantity: json['quantity'],
    price: json['price'].toDouble(),
  );
}