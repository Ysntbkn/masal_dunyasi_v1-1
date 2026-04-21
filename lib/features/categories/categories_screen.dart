import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/theme/app_theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const categories = [
    'Macera',
    'Uyku',
    'Dostluk',
    'Doğa',
    'Cesaret',
    'Komik',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategoriler')),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            color: Colors.white,
            child: InkWell(
              onTap: () =>
                  context.push(AppRoutes.category(category.toLowerCase())),
              borderRadius: BorderRadius.circular(22),
              child: Center(
                child: Text(
                  category,
                  style: const TextStyle(
                    color: AppColors.cinnamon,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
