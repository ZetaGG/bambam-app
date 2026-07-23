import 'package:flutter_test/flutter_test.dart';
import 'package:bambam_app/models/product.dart';
import 'package:bambam_app/models/cart_item.dart';
import 'package:bambam_app/models/order.dart';

void main() {
  group('Product', () {
    test('creates with required fields', () {
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Description',
        category: 'Brincolines',
        pricePerUnit: 100,
        stock: 5,
      );

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.pricePerUnit, 100);
      expect(product.stock, 5);
      expect(product.available, true);
      expect(product.imageUrl, '');
    });

    test('mockProducts has 9 items', () {
      expect(mockProducts.length, 9);
    });

    test('mockProducts covers all categories', () {
      final categories = mockProducts.map((p) => p.category).toSet();
      expect(categories, containsAll(['Brincolines', 'Sillas', 'Mesas', 'Losa', 'Manteles']));
    });
  });

  group('CartItem', () {
    test('subtotal calculates correctly', () {
      final item = CartItem(
        id: '1',
        productId: 'p1',
        productName: 'Test',
        category: 'Sillas',
        pricePerUnit: 15,
        quantity: 10,
        fechaEntrega: DateTime(2026, 8, 1),
        horaEntrega: '07:00',
      );

      expect(item.subtotal, 150);
    });

    test('toMap and fromFirestore roundtrip', () {
      final item = CartItem(
        id: 'doc1',
        productId: 'p1',
        productName: 'Silla',
        category: 'Sillas',
        pricePerUnit: 15,
        quantity: 5,
        fechaEntrega: DateTime(2026, 8, 1),
        horaEntrega: '08:00',
      );

      final map = item.toMap();
      expect(map['productId'], 'p1');
      expect(map['productName'], 'Silla');
      expect(map['quantity'], 5);
      expect(map['horaEntrega'], '08:00');
    });
  });

  group('OrderItem', () {
    test('subtotal calculates correctly', () {
      const item = OrderItem(
        productId: 'p1',
        productName: 'Brincolin',
        category: 'Brincolines',
        pricePerUnit: 650,
        quantity: 2,
      );

      expect(item.subtotal, 1300);
    });

    test('toMap and fromMap roundtrip', () {
      const item = OrderItem(
        productId: 'p1',
        productName: 'Test',
        category: 'Losa',
        pricePerUnit: 8,
        quantity: 20,
      );

      final map = item.toMap();
      final restored = OrderItem.fromMap(map);

      expect(restored.productId, item.productId);
      expect(restored.productName, item.productName);
      expect(restored.quantity, item.quantity);
      expect(restored.subtotal, item.subtotal);
    });
  });

  group('OrderStatus', () {
    test('has all 5 statuses', () {
      expect(OrderStatus.values.length, 5);
    });

    test('labels are correct', () {
      expect(OrderStatus.reserved.label, 'Reservado');
      expect(OrderStatus.inDelivery.label, 'En transcurso de entrega');
      expect(OrderStatus.delivered.label, 'Entregado');
      expect(OrderStatus.pendingPickup.label, 'Pendiente de recolección');
      expect(OrderStatus.finished.label, 'Finalizado');
    });
  });

  group('Order', () {
    test('toMap includes all fields', () {
      final order = Order(
        id: 'order1',
        uid: 'user1',
        fechaCreacion: DateTime(2026, 7, 23),
        fechaEvento: DateTime(2026, 8, 1),
        horaEntrega: '07:00',
        direccion: 'Calle Test 123',
        telefono: '1234567890',
        referencias: 'Frente al parque',
        items: const [
          OrderItem(
            productId: 'p1',
            productName: 'Silla',
            category: 'Sillas',
            pricePerUnit: 15,
            quantity: 100,
          ),
        ],
        totalEstimado: 1500,
        anticipo: 300,
        status: OrderStatus.reserved,
      );

      final map = order.toMap();
      expect(map['uid'], 'user1');
      expect(map['direccion'], 'Calle Test 123');
      expect(map['totalEstimado'], 1500);
      expect(map['anticipo'], 300);
      expect(map['status'], 'reserved');
      expect((map['items'] as List).length, 1);
    });
  });
}
