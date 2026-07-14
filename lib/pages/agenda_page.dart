import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.event_note_outlined,
      title: 'No tienes pedidos agendados',
      subtitle: 'Los pedidos que registres aparecerán aquí para que puedas darles seguimiento',
      actionLabel: 'Ir al inicio',
    );
  }
}
