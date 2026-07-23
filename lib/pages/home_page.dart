import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import '../utils/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';
  String? _selectedCategory;

  static const _categories = [
    'Todos',
    'Brincolines',
    'Sillas',
    'Mesas',
    'Losa',
    'Manteles',
  ];

  List<Product> _filterProducts(List<Product> products) {
    return products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'Todos' ||
          p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            backgroundColor: AppColors.sliverAppBarBackground,
            foregroundColor: AppColors.sliverAppBarForeground,
            toolbarHeight: 56,
            title: Row(
              children: [
                Icon(Icons.celebration_outlined, color: colorScheme.primary, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'BanBan',
                  style: TextStyle(
                    color: AppColors.sliverAppBarForeground,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.sliverAppBarForeground),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(child: _HeroBanner(colorScheme: colorScheme)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = (_selectedCategory == null && cat == 'Todos') ||
                        _selectedCategory == cat;
                    return FilterChip(
                      label: Text(cat, style: const TextStyle(fontSize: 13)),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = cat == 'Todos' ? null : cat;
                        });
                      },
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.primary,
                      side: BorderSide(
                        color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<List<Product>>(
            stream: _firestoreService.productsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.error_outline,
                    title: 'Error al cargar productos',
                    subtitle: 'No se pudieron cargar los productos desde la base de datos',
                    actionLabel: 'Reintentar',
                    onAction: () => setState(() {}),
                  ),
                );
              }

              final allProducts = snapshot.data ?? [];
              final products = _filterProducts(allProducts);

              if (allProducts.isEmpty) {
                return const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No hay productos disponibles',
                    subtitle: 'Aún no se han agregado productos al catálogo',
                  ),
                );
              }

              if (products.isEmpty) {
                return const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.search_off,
                    title: 'No se encontraron productos',
                    subtitle: 'Intenta con otra búsqueda o categoría',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    int crossAxisCount = 1;
                    if (width > 600) crossAxisCount = 2;
                    if (width > 900) crossAxisCount = 3;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push(
                              '/product/${product.id}',
                              extra: product,
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeroBanner({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.tertiary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡La fiesta perfecta te espera!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Renta brincolines, sillas, mesas y más para tu evento en Uruapan.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Icon(
                  Icons.celebration,
                  size: 64,
                  color: colorScheme.tertiary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
