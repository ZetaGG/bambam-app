import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../services/firestore_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<AppNotification> _notifications = [];
  StreamSubscription<dynamic>? _subscription;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.read).length;
  bool get isEmpty => _notifications.isEmpty;

  void subscribeToNotifications(String uid) {
    _subscription?.cancel();
    _subscription =
        _firestoreService.notificationsStream(uid).listen((dynamic items) {
      _notifications = items as List<AppNotification>;
      notifyListeners();
    });
  }

  void unsubscribeFromNotifications() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    await _firestoreService.markNotificationAsRead(uid, notificationId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
