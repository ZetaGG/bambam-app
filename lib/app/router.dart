import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../pages/cart_page.dart';
import '../pages/agenda_page.dart';
import '../pages/profile_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/checkout_page.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _MainShellWithRouter(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CartPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AgendaPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),
    GoRoute(
      path: '/checkout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutPage(),
    ),
  ],
);

class _MainShellWithRouter extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShellWithRouter({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Consumer<CartProvider>(
              builder: (context, cart, _) {
                final count = cart.itemCount;
                if (count == 0) {
                  return const Icon(Icons.shopping_cart_outlined);
                }
                return Badge(
                  label: Text('$count', style: const TextStyle(fontSize: 10)),
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            selectedIcon: Consumer<CartProvider>(
              builder: (context, cart, _) {
                final count = cart.itemCount;
                if (count == 0) {
                  return const Icon(Icons.shopping_cart);
                }
                return Badge(
                  label: Text('$count', style: const TextStyle(fontSize: 10)),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Carrito',
          ),
          const NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Pedidos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
