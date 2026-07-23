import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/category_utils.dart';
import '../widgets/order_status_chip.dart';
import '../widgets/order_status_timeline.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id.substring(0, 6).toUpperCase()}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderStatusChip(status: order.status),
                  const SizedBox(height: 12),
                  Text(
                    '\$${order.totalEstimado.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Anticipo: \$${order.anticipo.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: OrderStatusTimeline(currentStatus: order.status),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Fecha del evento', colorScheme: colorScheme),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    text: '${order.fechaEvento.day}/${order.fechaEvento.month}/${order.fechaEvento.year}',
                    colorScheme: colorScheme,
                  ),
                  _InfoRow(
                    icon: Icons.access_time,
                    text: order.horaEntrega,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'Dirección', colorScheme: colorScheme),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: order.direccion.isNotEmpty ? order.direccion : 'No especificada',
                    colorScheme: colorScheme,
                  ),
                  if (order.referencias != null && order.referencias!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _InfoRow(
                      icon: Icons.info_outline,
                      text: order.referencias!,
                      colorScheme: colorScheme,
                    ),
                  ],
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'Productos', colorScheme: colorScheme),
                  const SizedBox(height: 8),
                  ...order.items.map((item) => _OrderItemRow(
                        item: item,
                        colorScheme: colorScheme,
                      )),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'Resumen', colorScheme: colorScheme),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Productos',
                    value: '${order.items.fold<int>(0, (sum, item) => sum + item.quantity)} unidades',
                    colorScheme: colorScheme,
                  ),
                  _SummaryRow(
                    label: 'Subtotal',
                    value: '\$${order.totalEstimado.toStringAsFixed(2)}',
                    colorScheme: colorScheme,
                  ),
                  _SummaryRow(
                    label: 'Anticipo (20%)',
                    value: '\$${order.anticipo.toStringAsFixed(2)}',
                    colorScheme: colorScheme,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total',
                    value: '\$${order.totalEstimado.toStringAsFixed(2)}',
                    colorScheme: colorScheme,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;

  const _SectionTitle({required this.title, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  final ColorScheme colorScheme;

  const _OrderItemRow({required this.item, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                categoryIcon(item.category),
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${item.quantity} x \$${item.pricePerUnit.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${item.subtotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.tertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  color: isBold ? colorScheme.primary : colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
