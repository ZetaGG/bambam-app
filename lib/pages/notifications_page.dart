import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: Consumer2<AppAuthProvider, NotificationsProvider>(
        builder: (context, auth, notifications, child) {
          if (!auth.isAuthenticated) {
            return const EmptyState(
              icon: Icons.notifications_outlined,
              title: 'Inicia sesión para ver notificaciones',
              subtitle: 'Las notificaciones de tus pedidos aparecerán aquí',
            );
          }

          if (notifications.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_outlined,
              title: 'Sin notificaciones',
              subtitle: 'Recibirás avisos sobre el estado de tus pedidos',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.notifications.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = notifications.notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.read
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.primaryContainer,
                  child: Icon(
                    notification.read
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                    size: 20,
                    color: notification.read
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.read ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification.body),
                trailing: !notification.read
                    ? IconButton(
                        icon: Icon(
                          Icons.mark_email_read,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        onPressed: () {
                          notifications.markAsRead(
                            auth.user!.uid,
                            notification.id,
                          );
                        },
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
