import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const badges = [
    'İlk Masal',
    'Gece Okuru',
    'Dostluk',
    'Cesaret',
    'Haftalık Seri',
    'Uyku Ustası',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rozetler')),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        itemCount: badges.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.cinnamon,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(badges[index], textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}
