import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  reserved,
  inDelivery,
  delivered,
  pendingPickup,
  finished;

  String get label {
    switch (this) {
      case OrderStatus.reserved:
        return 'Reservado';
      case OrderStatus.inDelivery:
        return 'En transcurso de entrega';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.pendingPickup:
        return 'Pendiente de recolección';
      case OrderStatus.finished:
        return 'Finalizado';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String category;
  final double pricePerUnit;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.category,
    required this.pricePerUnit,
    required this.quantity,
  });

  double get subtotal => pricePerUnit * quantity;

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      category: data['category'] ?? '',
      pricePerUnit: (data['pricePerUnit'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'category': category,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
    };
  }
}

class Order {
  final String id;
  final String uid;
  final DateTime fechaCreacion;
  final DateTime fechaEvento;
  final String horaEntrega;
  final String direccion;
  final String telefono;
  final String? referencias;
  final List<OrderItem> items;
  final double totalEstimado;
  final double anticipo;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.uid,
    required this.fechaCreacion,
    required this.fechaEvento,
    required this.horaEntrega,
    required this.direccion,
    required this.telefono,
    this.referencias,
    required this.items,
    required this.totalEstimado,
    required this.anticipo,
    required this.status,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final itemsData = data['items'] as List<dynamic>? ?? [];

    return Order(
      id: doc.id,
      uid: data['uid'] ?? '',
      fechaCreacion: (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaEvento: (data['fechaEvento'] as Timestamp?)?.toDate() ?? DateTime.now(),
      horaEntrega: data['horaEntrega'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      referencias: data['referencias'],
      items: itemsData.map((item) => OrderItem.fromMap(item)).toList(),
      totalEstimado: (data['totalEstimado'] ?? 0).toDouble(),
      anticipo: (data['anticipo'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.reserved,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaEvento': Timestamp.fromDate(fechaEvento),
      'horaEntrega': horaEntrega,
      'direccion': direccion,
      'telefono': telefono,
      'referencias': referencias,
      'items': items.map((item) => item.toMap()).toList(),
      'totalEstimado': totalEstimado,
      'anticipo': anticipo,
      'status': status.name,
    };
  }
}
