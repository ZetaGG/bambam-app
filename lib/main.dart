import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/app_colors.dart';
import 'app/router.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/notifications_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BanBanApp());
}

class BanBanApp extends StatelessWidget {
  const BanBanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: CartSyncListener(
        child: MaterialApp.router(
          title: 'BanBan',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF8B7362),
              onPrimary: Color(0xFFFFFFFF),
              primaryContainer: Color(0xFFF0EAE3),
              onPrimaryContainer: Color(0xFF2B1F15),
              secondary: Color(0xFF5A7D7B),
              onSecondary: Color(0xFFFFFFFF),
              secondaryContainer: Color(0xFFD6EBE8),
              onSecondaryContainer: Color(0xFF003735),
              tertiary: Color(0xFFD67A2A),
              onTertiary: Color(0xFFFFFFFF),
              tertiaryContainer: Color(0xFFFFDBC2),
              onTertiaryContainer: Color(0xFF3D2000),
              error: Color(0xFFBA1A1A),
              onError: Color(0xFFFFFFFF),
              surface: Color(0xFFFDF8F5),
              onSurface: Color(0xFF1C1B1A),
              surfaceContainerHighest: Color(0xFFEFECE6),
              onSurfaceVariant: Color(0xFF50443B),
              outline: Color(0xFF837468),
              outlineVariant: Color(0xFFD3C4B8),
              shadow: Color(0xFF000000),
              inverseSurface: Color(0xFF312F2D),
              onInverseSurface: Color(0xFFF5F0EB),
              inversePrimary: Color(0xFFDDC5B4),
            ),
            useMaterial3: true,
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.navBarBackground,
              indicatorColor: Color(0xFF8B7362).withValues(alpha: 0.2),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Color(0xFF8B7362), size: 24);
                }
                return const IconThemeData(color: Color(0xFF8B7362), size: 24);
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Color(0xFF8B7362),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  );
                }
                return const TextStyle(color: Color(0xFF8B7362), fontSize: 12);
              }),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.appBarBackground,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD67A2A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFFFDF8F5),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
            ),
            scaffoldBackgroundColor: const Color(0xFFFDF8F5),
          ),
        ),
      ),
    );
  }
}

class CartSyncListener extends StatefulWidget {
  final Widget child;

  const CartSyncListener({super.key, required this.child});

  @override
  State<CartSyncListener> createState() => _CartSyncListenerState();
}

class _CartSyncListenerState extends State<CartSyncListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCartWithAuth();
      context.read<AppAuthProvider>().addListener(_syncCartWithAuth);
    });
  }

  void _syncCartWithAuth() {
    final authProvider = context.read<AppAuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();
    final notificationsProvider = context.read<NotificationsProvider>();
    final user = authProvider.user;

    if (user != null) {
      cartProvider.subscribeToCart(user.uid);
      ordersProvider.subscribeToOrders(user.uid);
      notificationsProvider.subscribeToNotifications(user.uid);
    } else {
      cartProvider.unsubscribeFromCart();
      ordersProvider.unsubscribeFromOrders();
      notificationsProvider.unsubscribeFromNotifications();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
