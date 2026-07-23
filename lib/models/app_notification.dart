import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? orderId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.orderId,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] ?? false,
      orderId: data['orderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
      'read': read,
      'orderId': orderId,
    };
  }
}
