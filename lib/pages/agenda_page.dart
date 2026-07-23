import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/order_card.dart';
import 'order_detail_page.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos')),
      body: Consumer2<AppAuthProvider, OrdersProvider>(
        builder: (context, auth, orders, child) {
          if (!auth.isAuthenticated) {
            return const EmptyState(
              icon: Icons.event_note_outlined,
              title: 'Inicia sesión para ver tus pedidos',
              subtitle: 'Inicia sesión para consultar el estado de tus rentas',
            );
          }

          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.event_note_outlined,
              title: 'No tienes pedidos agendados',
              subtitle: 'Los pedidos que registres aparecerán aquí para que puedas darles seguimiento',
              actionLabel: 'Ir al inicio',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final order = orders.orders[index];
              return OrderCard(
                order: order,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailPage(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
