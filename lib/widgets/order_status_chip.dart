import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon) = switch (status) {
      OrderStatus.reserved => (
          const Color(0xFF2196F3),
          Colors.white,
          Icons.event_available,
        ),
      OrderStatus.inDelivery => (
          const Color(0xFFFF9800),
          Colors.white,
          Icons.local_shipping,
        ),
      OrderStatus.delivered => (
          const Color(0xFF4CAF50),
          Colors.white,
          Icons.check_circle,
        ),
      OrderStatus.pendingPickup => (
          const Color(0xFF9C27B0),
          Colors.white,
          Icons.inventory_2,
        ),
      OrderStatus.finished => (
          const Color(0xFF607D8B),
          Colors.white,
          Icons.done_all,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
