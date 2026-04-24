class StoryCatalogEntry {
  const StoryCatalogEntry({
    required this.id,
    required this.title,
    required this.imagePath,
    this.totalPages = 5,
  });

  final String id;
  final String title;
  final String imagePath;
  final int totalPages;
}

const defaultStoryImagePath = 'asset/sleep page/sleep_card_bear_thumb.jpg';

const Map<String, StoryCatalogEntry> storyCatalog = {
  'ucretsiz-masallar': StoryCatalogEntry(
    id: 'ucretsiz-masallar',
    title: 'Ucretsiz Masallar',
    imagePath: defaultStoryImagePath,
  ),
  'ormani-kesfet': StoryCatalogEntry(
    id: 'ormani-kesfet',
    title: 'Ormani Kesfet',
    imagePath: defaultStoryImagePath,
  ),
  'minik-dostlar': StoryCatalogEntry(
    id: 'minik-dostlar',
    title: 'Minik Dostlar',
    imagePath: defaultStoryImagePath,
  ),
  'uyku-yolculugu': StoryCatalogEntry(
    id: 'uyku-yolculugu',
    title: 'Uyku Yolculugu',
    imagePath: defaultStoryImagePath,
  ),
  'ay-isigi-ormani': StoryCatalogEntry(
    id: 'ay-isigi-ormani',
    title: 'Ay Isigi Ormani',
    imagePath: defaultStoryImagePath,
  ),
  'ruzgarin-sarkisi': StoryCatalogEntry(
    id: 'ruzgarin-sarkisi',
    title: 'Ruzgarin Sarkisi',
    imagePath: defaultStoryImagePath,
  ),
  'bulut-sarayi': StoryCatalogEntry(
    id: 'bulut-sarayi',
    title: 'Bulut Sarayi',
    imagePath: defaultStoryImagePath,
  ),
  'isikli-kitap': StoryCatalogEntry(
    id: 'isikli-kitap',
    title: 'Isiltili Kitap',
    imagePath: defaultStoryImagePath,
  ),
  'ay-ormani': StoryCatalogEntry(
    id: 'ay-ormani',
    title: 'Ay Ormani',
    imagePath: defaultStoryImagePath,
  ),
  'minik-ejderha': StoryCatalogEntry(
    id: 'minik-ejderha',
    title: 'Minik Ejderha',
    imagePath: defaultStoryImagePath,
  ),
  'bulut-sarayi-trial': StoryCatalogEntry(
    id: 'bulut-sarayi-trial',
    title: 'Bulut Sarayi',
    imagePath: defaultStoryImagePath,
  ),
};

StoryCatalogEntry storyCatalogEntryFor(String storyId) {
  return storyCatalog[storyId] ??
      StoryCatalogEntry(
        id: storyId,
        title: storyTitleFromId(storyId),
        imagePath: defaultStoryImagePath,
      );
}

String storyTitleFromId(String id) {
  return id
      .split('-')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}
