import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/category_utils.dart';
import '../utils/formatters.dart';
import '../widgets/outlined_picker.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _cantidad = 1;
  DateTime? _seleccionarFecha;
  TimeOfDay? _selecionarHora;

  double get _totalPrice => widget.product.pricePerUnit * _cantidad;

  void _addToCart() {
    final authProvider = context.read<AppAuthProvider>();
    final cartProvider = context.read<CartProvider>();

    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicia sesión para agregar productos al carrito'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_seleccionarFecha == null || _selecionarHora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una fecha y horario antes de agregar'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final existingDate = cartProvider.fechaEntrega;
    if (existingDate != null && cartProvider.items.isNotEmpty) {
      final sameDate = existingDate.year == _seleccionarFecha!.year &&
          existingDate.month == _seleccionarFecha!.month &&
          existingDate.day == _seleccionarFecha!.day;
      final sameTime = cartProvider.horaEntrega == formatTime(_selecionarHora!);

      if (!sameDate || !sameTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ya tienes productos con fecha ${existingDate.day}/${existingDate.month}/${existingDate.year} a las ${cartProvider.horaEntrega}. Modifica la fecha/hora existente o vacía el carrito.',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }
    }

    cartProvider.addToCart(
      uid: authProvider.user!.uid,
      product: widget.product,
      quantity: _cantidad,
      fechaEntrega: _seleccionarFecha!,
      horaEntrega: formatTime(_selecionarHora!),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} agregado al carrito'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(product: product, colorScheme: colorScheme),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductHeader(product: product, theme: theme, colorScheme: colorScheme),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.inventory, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Stock disponible: ${product.stock}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Configurar renta',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedPicker(
                          icon: Icons.calendar_today,
                          label: _seleccionarFecha != null
                              ? '${_seleccionarFecha!.day}/${_seleccionarFecha!.month}/${_seleccionarFecha!.year}'
                              : 'Seleccionar fecha',
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) setState(() => _seleccionarFecha = date);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedPicker(
                          icon: Icons.access_time,
                          label: _selecionarHora != null
                              ? _selecionarHora!.format(context)
                              : 'Seleccionar horario',
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 7, minute: 0),
                            );
                            if (time != null) setState(() => _selecionarHora = time);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _QuantitySelector(
                    cantidad: _cantidad,
                    maxStock: product.stock,
                    onChanged: (qty) => setState(() => _cantidad = qty),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total estimado',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Agregar al carrito'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.tertiary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;
  final ColorScheme colorScheme;

  const _ProductImage({required this.product, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: colorScheme.primaryContainer,
      child: Stack(
        children: [
          Center(
            child: Icon(
              categoryIcon(product.category),
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF598F55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Disponible',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final Product product;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _ProductHeader({
    required this.product,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Precio por unidad',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${product.pricePerUnit.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int cantidad;
  final int maxStock;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({
    required this.cantidad,
    required this.maxStock,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'Cantidad:',
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            onPressed: cantidad > 1 ? () => onChanged(cantidad - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: colorScheme.primary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Text(
              '$cantidad',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: cantidad < maxStock ? () => onChanged(cantidad + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
