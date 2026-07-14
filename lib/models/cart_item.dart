import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String category;
  final double pricePerUnit;
  int quantity;
  final DateTime fechaEntrega;
  final String horaEntrega;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.pricePerUnit,
    required this.quantity,
    required this.fechaEntrega,
    required this.horaEntrega,
  });

  double get subtotal => pricePerUnit * quantity;

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      category: data['category'] ?? '',
      pricePerUnit: (data['pricePerUnit'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
      fechaEntrega: (data['fechaEntrega'] as Timestamp?)?.toDate() ?? DateTime.now(),
      horaEntrega: data['horaEntrega'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'category': category,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'fechaEntrega': Timestamp.fromDate(fechaEntrega),
      'horaEntrega': horaEntrega,
    };
  }
}
