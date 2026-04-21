import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/section_scaffold.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Kategori: $categoryId',
      children: [
        StoryCard(
          title: '$categoryId Masalı 1',
          subtitle: 'Kategori koleksiyonu',
          onTap: () => context.push(AppRoutes.story('$categoryId-1')),
        ),
        StoryCard(
          title: '$categoryId Masalı 2',
          subtitle: 'Kategori koleksiyonu',
          onTap: () => context.push(AppRoutes.story('$categoryId-2')),
        ),
      ],
    );
  }
}
