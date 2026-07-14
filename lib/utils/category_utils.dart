import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Brincolines':
      return Icons.child_care;
    case 'Sillas':
      return Icons.chair;
    case 'Mesas':
      return Icons.table_restaurant;
    case 'Losa':
      return Icons.dinner_dining;
    case 'Manteles':
      return Icons.texture;
    default:
      return Icons.inventory_2;
  }
}
