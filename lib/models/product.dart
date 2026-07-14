class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double pricePerUnit;
  final int stock;
  final String imageUrl;
  final bool available;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.pricePerUnit,
    required this.stock,
    this.imageUrl = '',
    this.available = true,
  });
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Brincolín Grande',
    description: 'Brincolín de tamaño grande para fiestas infantiles. Capacidad para 8 niños.',
    category: 'Brincolines',
    pricePerUnit: 650,
    stock: 3,
  ),
  Product(
    id: '2',
    name: 'Brincolín Chico',
    description: 'Brincolín pequeño ideal para espacios reducidos. Capacidad para 4 niños.',
    category: 'Brincolines',
    pricePerUnit: 450,
    stock: 5,
  ),
  Product(
    id: '3',
    name: 'Brincolín Redondo',
    description: 'Brincolín redondo clásico. Capacidad para 6 niños.',
    category: 'Brincolines',
    pricePerUnit: 550,
    stock: 2,
  ),
  Product(
    id: '4',
    name: 'Brincolín Acuático',
    description: 'Brincolín con agua para días calurosos. Capacidad para 6 niños.',
    category: 'Brincolines',
    pricePerUnit: 750,
    stock: 2,
  ),
  Product(
    id: '5',
    name: 'Silla Plegable',
    description: 'Silla plegable de plástico resistente, ideal para eventos.',
    category: 'Sillas',
    pricePerUnit: 15,
    stock: 300,
  ),
  Product(
    id: '6',
    name: 'Mesa Plegable',
    description: 'Mesa plegable de 1.80m, ideal para comidas y reuniones.',
    category: 'Mesas',
    pricePerUnit: 50,
    stock: 30,
  ),
  Product(
    id: '7',
    name: 'Plato Hondo',
    description: 'Plato hondo de losa blanca clásica.',
    category: 'Losa',
    pricePerUnit: 8,
    stock: 200,
  ),
  Product(
    id: '8',
    name: 'Vaso',
    description: 'Vaso de vidrio templado estándar.',
    category: 'Losa',
    pricePerUnit: 5,
    stock: 200,
  ),
  Product(
    id: '9',
    name: 'Mantel Rectangular',
    description: 'Mantel rectangular de tela para mesa de 1.80m. Varios colores disponibles.',
    category: 'Manteles',
    pricePerUnit: 30,
    stock: 100,
  ),
];
