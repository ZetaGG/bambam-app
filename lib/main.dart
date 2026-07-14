import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/agenda_page.dart';
import 'pages/profile_page.dart';

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
      ],
      child: MaterialApp(
        title: 'BanBan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: const Color(0xFF8B7362),
            onPrimary: const Color(0xFFFFFFFF),
            primaryContainer: const Color(0xFFF0EAE3),
            onPrimaryContainer: const Color(0xFF2B1F15),
            secondary: const Color(0xFF5A7D7B),
            onSecondary: const Color(0xFFFFFFFF),
            secondaryContainer: const Color(0xFFD6EBE8),
            onSecondaryContainer: const Color(0xFF003735),
            tertiary: const Color(0xFFD67A2A),
            onTertiary: const Color(0xFFFFFFFF),
            tertiaryContainer: const Color(0xFFFFDBC2),
            onTertiaryContainer: const Color(0xFF3D2000),
            error: const Color(0xFFBA1A1A),
            onError: const Color(0xFFFFFFFF),
            surface: const Color(0xFFFDF8F5),
            onSurface: const Color(0xFF1C1B1A),
            surfaceContainerHighest: const Color(0xFFEFECE6),
            onSurfaceVariant: const Color(0xFF50443B),
            outline: const Color(0xFF837468),
            outlineVariant: const Color(0xFFD3C4B8),
            shadow: const Color(0xFF000000),
            inverseSurface: const Color(0xFF312F2D),
            onInverseSurface: const Color(0xFFF5F0EB),
            inversePrimary: const Color(0xFFDDC5B4),
          ),
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: const Color(0xFFDDD5CA),
            indicatorColor: const Color(0xFF8B7362).withValues(alpha: 0.2),
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
            backgroundColor: Color(0xFFA39381),
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
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    AgendaPage(),
    ProfilePage(),
  ];

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
    final user = authProvider.user;

    if (user != null) {
      cartProvider.subscribeToCart(user.uid);
    } else {
      cartProvider.unsubscribeFromCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),

          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
