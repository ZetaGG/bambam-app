import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/profile_option.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppAuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authProvider.user != null) {
            return _buildAuthenticatedProfile(context, authProvider.user!, authProvider);
          }
          return _buildGuestProfile(context, authProvider);
        },
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context, AppAuthProvider authProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 48, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Mi cuenta',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Inicia sesión para gestionar tus pedidos y ver tu historial',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final success = await authProvider.signInWithGoogle();
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No se pudo iniciar sesión. Intenta de nuevo.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión con Google'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context, User user, AppAuthProvider authProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null ? Icon(Icons.person, size: 48, color: colorScheme.primary) : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? 'Sin nombre',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          ProfileOption(icon: Icons.shopping_bag_outlined, title: 'Mis pedidos', onTap: () {}),
          ProfileOption(icon: Icons.location_on_outlined, title: 'Direcciones', onTap: () {}),
          ProfileOption(icon: Icons.notifications_outlined, title: 'Notificaciones', onTap: () => context.push('/notifications')),
          ProfileOption(icon: Icons.help_outline, title: 'Ayuda', onTap: () {}),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await FirestoreService().seedProducts();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Productos de ejemplo cargados en Firestore'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Cargar productos de ejemplo'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => authProvider.signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
