import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_back_button.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _backgroundImage =
      'asset/kategoriler page/arkaplan_optimized.jpg';

  static const _categories = [
    _CategoryTileData('macera', 'Macera'),
    _CategoryTileData('uyku', 'Uyku'),
    _CategoryTileData('dostluk', 'Dostluk'),
    _CategoryTileData('doga', 'Do\u011fa'),
    _CategoryTileData('cesaret', 'Cesaret'),
    _CategoryTileData('komik', 'Komik'),
    _CategoryTileData('hayvanlar', 'Hayvanlar'),
    _CategoryTileData('fantastik', 'Fantastik'),
    _CategoryTileData('egitici', 'E\u011fitici'),
    _CategoryTileData('meslekler', 'Meslekler'),
    _CategoryTileData('klasikler', 'Klasikler'),
    _CategoryTileData('uzay', 'Uzay'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final backgroundCacheWidth = (screenWidth * devicePixelRatio).round();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF1E4D8C),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E4D8C),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                _backgroundImage,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.medium,
                cacheWidth: backgroundCacheWidth,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.42),
                      Colors.black.withValues(alpha: 0.24),
                      const Color(0xFF2D66A8).withValues(alpha: 0.12),
                      const Color(0xFF1F5A9E).withValues(alpha: 0.72),
                      const Color(0xFF1E4D8C),
                    ],
                    stops: const [0, 0.08, 0.26, 0.60, 1],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Column(
                  children: [
                    AppHeaderBar(
                      onBack: () => Navigator.of(context).maybePop(),
                      horizontalPadding: 0,
                    ),
                    const SizedBox(height: 210),
                    const Text(
                      'KATEGOR\u0130LER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BreadMateTR',
                        fontSize: 54,
                        height: 0.92,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          0,
                          0,
                          MediaQuery.paddingOf(context).bottom + 120,
                        ),
                        itemCount: _categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.92,
                            ),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return _CategoryCard(category: category);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final _CategoryTileData category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.category(category.id)),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTileData {
  const _CategoryTileData(this.id, this.title);

  final String id;
  final String title;
}
