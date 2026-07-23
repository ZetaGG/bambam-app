import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'photoUrl': photoUrl ?? '',
      'rol': 'cliente',
      'telefono': '',
      'direccion': '',
      'fechaCreacion': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Product _productFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['nombre'] ?? '',
      description: data['descripcion'] ?? '',
      category: data['categoria'] ?? '',
      pricePerUnit: (data['precio'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      imageUrl: data['imagenUrl'] ?? '',
      available: data['disponible'] ?? true,
    );
  }

  Future<List<Product>> getProducts() async {
    final snapshot = await _db
        .collection('products')
        .where('disponible', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => _productFromDoc(doc)).toList();
  }

  Stream<List<Product>> productsStream() {
    return _db
        .collection('products')
        .where('disponible', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _productFromDoc(doc)).toList());
  }

  // --- Cart methods ---

  String _cartPath(String uid) => 'users/$uid/cart';

  Stream<List<CartItem>> cartStream(String uid) {
    return _db.collection(_cartPath(uid)).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList(),
    );
  }

  Future<void> addToCart({
    required String uid,
    required Product product,
    required int quantity,
    required DateTime fechaEntrega,
    required String horaEntrega,
  }) async {
    final existing = await _db
        .collection(_cartPath(uid))
        .where('productId', isEqualTo: product.id)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final currentQty = doc.data()['quantity'] ?? 1;
      await doc.reference.update({
        'quantity': currentQty + quantity,
      });
    } else {
      await _db.collection(_cartPath(uid)).add({
        'productId': product.id,
        'productName': product.name,
        'category': product.category,
        'pricePerUnit': product.pricePerUnit,
        'quantity': quantity,
        'fechaEntrega': Timestamp.fromDate(fechaEntrega),
        'horaEntrega': horaEntrega,
      });
    }
  }

  Future<void> updateCartItemQuantity({
    required String uid,
    required String cartItemId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await removeFromCart(uid: uid, cartItemId: cartItemId);
    } else {
      await _db.collection(_cartPath(uid)).doc(cartItemId).update({
        'quantity': quantity,
      });
    }
  }

  Future<void> removeFromCart({
    required String uid,
    required String cartItemId,
  }) async {
    await _db.collection(_cartPath(uid)).doc(cartItemId).delete();
  }

  Future<void> clearCart(String uid) async {
    final snapshot = await _db.collection(_cartPath(uid)).get();
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // --- Seed ---

  Future<void> seedProducts() async {
    final batch = _db.batch();

    final products = [
      {'nombre': 'Brincolín Grande', 'descripcion': 'Brincolín de tamaño grande para fiestas infantiles. Capacidad para 8 niños.', 'categoria': 'Brincolines', 'precio': 650, 'stock': 3, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Brincolín Chico', 'descripcion': 'Brincolín pequeño ideal para espacios reducidos. Capacidad para 4 niños.', 'categoria': 'Brincolines', 'precio': 450, 'stock': 5, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Brincolín Redondo', 'descripcion': 'Brincolín redondo clásico. Capacidad para 6 niños.', 'categoria': 'Brincolines', 'precio': 550, 'stock': 2, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Brincolín Acuático', 'descripcion': 'Brincolín con agua para días calurosos. Capacidad para 6 niños.', 'categoria': 'Brincolines', 'precio': 750, 'stock': 2, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Silla Plegable', 'descripcion': 'Silla plegable de plástico resistente, ideal para eventos.', 'categoria': 'Sillas', 'precio': 15, 'stock': 300, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Mesa Plegable', 'descripcion': 'Mesa plegable de 1.80m, ideal para comidas y reuniones.', 'categoria': 'Mesas', 'precio': 50, 'stock': 30, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Plato Hondo', 'descripcion': 'Plato hondo de losa blanca clásica.', 'categoria': 'Losa', 'precio': 8, 'stock': 200, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Vaso', 'descripcion': 'Vaso de vidrio templado estándar.', 'categoria': 'Losa', 'precio': 5, 'stock': 200, 'disponible': true, 'imagenUrl': ''},
      {'nombre': 'Mantel Rectangular', 'descripcion': 'Mantel rectangular de tela para mesa de 1.80m. Varios colores disponibles.', 'categoria': 'Manteles', 'precio': 30, 'stock': 100, 'disponible': true, 'imagenUrl': ''},
    ];

    for (final product in products) {
      final ref = _db.collection('products').doc();
      batch.set(ref, product);
    }

    await batch.commit();
  }
}
