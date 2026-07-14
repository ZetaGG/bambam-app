import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CartItem> _items = [];
  StreamSubscription<List<CartItem>>? _subscription;

  List<CartItem> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  DateTime? get fechaEntrega => _items.isNotEmpty ? _items.first.fechaEntrega : null;
  String get horaEntrega => _items.isNotEmpty ? _items.first.horaEntrega : '';

  void subscribeToCart(String uid) {
    _subscription?.cancel();
    _subscription = _firestoreService.cartStream(uid).listen((items) {
      _items = items;
      notifyListeners();
    });
  }

  void unsubscribeFromCart() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> addToCart({
    required String uid,
    required Product product,
    required int quantity,
    required DateTime fechaEntrega,
    required String horaEntrega,
  }) async {
    await _firestoreService.addToCart(
      uid: uid,
      product: product,
      quantity: quantity,
      fechaEntrega: fechaEntrega,
      horaEntrega: horaEntrega,
    );
  }

  Future<void> updateQuantity({
    required String uid,
    required String cartItemId,
    required int quantity,
  }) async {
    await _firestoreService.updateCartItemQuantity(
      uid: uid,
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }

  Future<void> removeItem({
    required String uid,
    required String cartItemId,
  }) async {
    await _firestoreService.removeFromCart(
      uid: uid,
      cartItemId: cartItemId,
    );
  }

  Future<void> clearCart(String uid) async {
    await _firestoreService.clearCart(uid);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
