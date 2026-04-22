import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _coverImage =
      'asset/books/freepik_cute-little-bear-standing_2791150604.png';

  static const _items = [
    _SearchItem('ucretsiz-masallar', '\u00dccretsiz Masallar', 'Masal'),
    _SearchItem('ormani-kesfet', 'Orman\u0131 Ke\u015ffet', 'Masal'),
    _SearchItem('minik-dostlar', 'Minik Dostlar', 'Masal'),
    _SearchItem('uyku-yolculugu', 'Uyku Yolculu\u011fu', 'Masal'),
    _SearchItem('macera', 'Macera', 'Kategori', isCategory: true),
    _SearchItem('hayvanlar', 'Hayvanlar Alemi', 'Kategori', isCategory: true),
    _SearchItem('fantastik', 'Fantastik', 'Kategori', isCategory: true),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = _items.where((item) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return item.title.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEDF8FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDF8FD),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri',
        ),
        title: const Text(
          'Arama',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            TextField(
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Masal veya kategori ara',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            for (final item in results) ...[
              _SearchResultTile(item: item, imagePath: _coverImage),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.item, required this.imagePath});

  final _SearchItem item;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          final route = item.isCategory
              ? AppRoutes.category(item.id)
              : AppRoutes.story(item.id);
          context.push(route);
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.type,
                      style: const TextStyle(
                        color: AppColors.lavender,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.cinnamon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchItem {
  const _SearchItem(this.id, this.title, this.type, {this.isCategory = false});

  final String id;
  final String title;
  final String type;
  final bool isCategory;
}
