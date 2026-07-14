import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_footer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Vaciar carrito',
                onPressed: () => _confirmClearCart(context, cart),
              );
            },
          ),
        ],
      ),
      body: Consumer2<AppAuthProvider, CartProvider>(
        builder: (context, auth, cart, child) {
          if (!auth.isAuthenticated) {
            return const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Inicia sesión para ver tu carrito',
              subtitle: 'Crea una cuenta o inicia sesión para agregar productos',
            );
          }

          if (cart.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Tu carrito está vacío',
              subtitle: 'Explora el catálogo y agrega productos para empezar tu pedido',
              actionLabel: 'Explorar productos',
              onAction: () {},
            );
          }

          return _CartContent(cart: cart);
        },
      ),
    );
  }

  void _confirmClearCart(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los productos del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final uid = context.read<AppAuthProvider>().user!.uid;
              cart.clearCart(uid);
              Navigator.pop(ctx);
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartProvider cart;

  const _CartContent({required this.cart});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (cart.fechaEntrega != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: colorScheme.secondaryContainer,
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: colorScheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Entrega: ${cart.fechaEntrega!.day}/${cart.fechaEntrega!.month}/${cart.fechaEntrega!.year} a las ${cart.horaEntrega}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final uid = context.read<AppAuthProvider>().user!.uid;
              return CartItemCard(
                item: item,
                onIncrement: () => cart.updateQuantity(uid: uid, cartItemId: item.id, quantity: item.quantity + 1),
                onDecrement: () => cart.updateQuantity(uid: uid, cartItemId: item.id, quantity: item.quantity - 1),
                onRemove: () => cart.removeItem(uid: uid, cartItemId: item.id),
              );
            },
          ),
        ),
        CartFooter(cart: cart),
      ],
    );
  }
}
