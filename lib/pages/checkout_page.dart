import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import '../utils/category_utils.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _referenciasController = TextEditingController();
  bool _isPayFull = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _direccionController.dispose();
    _telefonoController.dispose();
    _referenciasController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final authProvider = context.read<AppAuthProvider>();
      final cartProvider = context.read<CartProvider>();
      final firestoreService = FirestoreService();
      final uid = authProvider.user!.uid;

      final items = cartProvider.items
          .map(
            (cartItem) => OrderItem(
              productId: cartItem.productId,
              productName: cartItem.productName,
              category: cartItem.category,
              pricePerUnit: cartItem.pricePerUnit,
              quantity: cartItem.quantity,
            ),
          )
          .toList();

      await firestoreService.createOrder(
        uid: uid,
        fechaEvento: cartProvider.fechaEntrega!,
        horaEntrega: cartProvider.horaEntrega,
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        referencias: _referenciasController.text.trim().isEmpty
            ? null
            : _referenciasController.text.trim(),
        items: items,
      );

      await firestoreService.clearCart(uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pedido confirmado exitosamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al confirmar pedido: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cart = context.watch<CartProvider>();
    final total = cart.total;
    final anticipo = total * 0.2;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar pedido')),
      body: cart.isEmpty
          ? const Center(
              child: Text('Tu carrito está vacío'),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderSummary(context, cart, colorScheme, theme),
                          const SizedBox(height: 24),
                          _buildContactForm(colorScheme, theme),
                          const SizedBox(height: 24),
                          _buildPaymentSection(colorScheme, theme, total, anticipo),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildBottomBar(colorScheme, theme, total, anticipo),
              ],
            ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    CartProvider cart,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del pedido',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: colorScheme.onSecondaryContainer),
              const SizedBox(width: 8),
              Text(
                'Entrega: ${cart.fechaEntrega!.day}/${cart.fechaEntrega!.month}/${cart.fechaEntrega!.year} a las ${cart.horaEntrega}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...cart.items.map((item) => Card(
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
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${item.quantity} x \$${item.pricePerUnit.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildContactForm(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos de contacto',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _direccionController,
          decoration: InputDecoration(
            labelText: 'Dirección de entrega',
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa la dirección de entrega';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _telefonoController,
          decoration: InputDecoration(
            labelText: 'Teléfono de contacto',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa un número de teléfono';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _referenciasController,
          decoration: InputDecoration(
            labelText: 'Referencias (opcional)',
            prefixIcon: const Icon(Icons.info_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: 'Ej: casa azul, frente al parque',
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildPaymentSection(
    ColorScheme colorScheme,
    ThemeData theme,
    double total,
    double anticipo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forma de pago',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _PaymentOption(
                  title: 'Anticipo (20%)',
                  subtitle: 'Paga \$${anticipo.toStringAsFixed(2)} ahora, el resto al entregar',
                  price: '\$${anticipo.toStringAsFixed(2)}',
                  isSelected: !_isPayFull,
                  onTap: () => setState(() => _isPayFull = false),
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                const Divider(height: 24),
                _PaymentOption(
                  title: 'Liquidación total',
                  subtitle: 'Paga el monto completo ahora',
                  price: '\$${total.toStringAsFixed(2)}',
                  isSelected: _isPayFull,
                  onTap: () => setState(() => _isPayFull = true),
                  colorScheme: colorScheme,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: colorScheme.onTertiaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pago simulado. No se realizará ningún cobro real.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    ColorScheme colorScheme,
    ThemeData theme,
    double total,
    double anticipo,
  ) {
    final payAmount = _isPayFull ? total : anticipo;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pagar ahora',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$${payAmount.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isProcessing ? null : _confirmOrder,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirmar pedido',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
