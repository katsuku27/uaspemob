import 'package:get/get.dart';

class TransactionItem {
  final int productId;
  RxInt quantity;
  final double price;

  TransactionItem({
    required this.productId,
    required int quantity,
    required this.price,
  }) : this.quantity = quantity.obs;

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity.value,
      'price': price,
    };
  }
}

class Transaction {
  final int id;
  final double totalAmount;
  final DateTime createdAt;
  final List<TransactionItem> items;

  Transaction({
    required this.id,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      items: [],
    );
  }
}