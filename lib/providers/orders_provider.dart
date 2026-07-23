import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/firestore_service.dart';

class OrdersProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Order> _orders = [];
  StreamSubscription<dynamic>? _subscription;

  List<Order> get orders => _orders;
  bool get isEmpty => _orders.isEmpty;

  void subscribeToOrders(String uid) {
    _subscription?.cancel();
    _subscription = _firestoreService.ordersStream(uid).listen((dynamic items) {
      _orders = items as List<Order>;
      notifyListeners();
    });
  }

  void unsubscribeFromOrders() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
