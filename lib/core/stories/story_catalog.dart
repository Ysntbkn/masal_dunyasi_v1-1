class StoryCatalogEntry {
  const StoryCatalogEntry({
    required this.id,
    required this.title,
    required this.imagePath,
    this.totalPages = 5,
    this.summary = 'Sicak, sakin ve cocuk dostu bir masal deneyimi.',
    this.categories = const <String>[],
    this.relatedStoryIds = const <String>[],
  });

  final String id;
  final String title;
  final String imagePath;
  final int totalPages;
  final String summary;
  final List<String> categories;
  final List<String> relatedStoryIds;
}

const defaultStoryImagePath = 'asset/sleep page/sleep_card_bear_thumb.jpg';

const Map<String, StoryCatalogEntry> storyCatalog = {
  'ucretsiz-masallar': StoryCatalogEntry(
    id: 'ucretsiz-masallar',
    title: 'Ucretsiz Masallar',
    imagePath: defaultStoryImagePath,
    summary: 'Nezaket, cesaret ve sicacik dostluklarla dolu keyifli bir secki.',
    categories: ['Dostluk', 'Macera', 'Yumusak', 'Aile'],
    relatedStoryIds: ['ormani-kesfet', 'minik-dostlar', 'uyku-yolculugu'],
  ),
  'ormani-kesfet': StoryCatalogEntry(
    id: 'ormani-kesfet',
    title: 'Ormani Kesfet',
    imagePath: defaultStoryImagePath,
    summary: 'Merakli kahramanimizla ormanda minik sirlari kesfedecegin yumusak bir yolculuk.',
    categories: ['Macera', 'Orman', 'Kesif', 'Hayvanlar'],
    relatedStoryIds: ['minik-dostlar', 'ay-isigi-ormani', 'uyku-yolculugu'],
  ),
  'minik-dostlar': StoryCatalogEntry(
    id: 'minik-dostlar',
    title: 'Minik Dostlar',
    imagePath: defaultStoryImagePath,
    summary: 'Kucuk dostlarin yardimlasma ve sevgiyle buyuyen sicacik hikayesi.',
    categories: ['Dostluk', 'Sevgi', 'Hayvanlar', 'Nazik'],
    relatedStoryIds: ['ormani-kesfet', 'minik-ejderha', 'ay-ormani'],
  ),
  'uyku-yolculugu': StoryCatalogEntry(
    id: 'uyku-yolculugu',
    title: 'Uyku Yolculugu',
    imagePath: defaultStoryImagePath,
    summary: 'Gunu sakinlikle kapatan, yumusak gecisli ve huzurlu bir uyku masali.',
    categories: ['Uyku', 'Sakin', 'Gece', 'Rahatlama'],
    relatedStoryIds: ['ay-isigi-ormani', 'ruzgarin-sarkisi', 'ay-ormani'],
  ),
  'ay-isigi-ormani': StoryCatalogEntry(
    id: 'ay-isigi-ormani',
    title: 'Ay Isigi Ormani',
    imagePath: defaultStoryImagePath,
    summary: 'Ay isiginin aydinlattigi buyulu bir ormanda huzurlu bir gece gezisi.',
    categories: ['Gece', 'Buyulu', 'Orman', 'Uyku'],
    relatedStoryIds: ['uyku-yolculugu', 'ay-ormani', 'ruzgarin-sarkisi'],
  ),
  'ruzgarin-sarkisi': StoryCatalogEntry(
    id: 'ruzgarin-sarkisi',
    title: 'Ruzgarin Sarkisi',
    imagePath: defaultStoryImagePath,
    summary: 'Ruzgarla fisildayan nazik melodiler esliginde dingin bir hikaye.',
    categories: ['Muzik', 'Sakin', 'Dogal', 'Uyku'],
    relatedStoryIds: ['uyku-yolculugu', 'ay-isigi-ormani', 'bulut-sarayi'],
  ),
  'bulut-sarayi': StoryCatalogEntry(
    id: 'bulut-sarayi',
    title: 'Bulut Sarayi',
    imagePath: defaultStoryImagePath,
    summary: 'Bulutlarin ustunde gecen yumusak, hayal dolu ve isiltilli bir macera.',
    categories: ['Fantastik', 'Hayal', 'Macera', 'Masalsi'],
    relatedStoryIds: ['isikli-kitap', 'minik-ejderha', 'ay-ormani'],
  ),
  'isikli-kitap': StoryCatalogEntry(
    id: 'isikli-kitap',
    title: 'Isiltili Kitap',
    imagePath: defaultStoryImagePath,
    summary: 'Her sayfasinda ayri bir surpriz saklayan isiltilli bir kitap hikayesi.',
    categories: ['Buyu', 'Kitap', 'Kesif', 'Fantastik'],
    relatedStoryIds: ['bulut-sarayi', 'minik-ejderha', 'ormani-kesfet'],
  ),
  'ay-ormani': StoryCatalogEntry(
    id: 'ay-ormani',
    title: 'Ay Ormani',
    imagePath: defaultStoryImagePath,
    summary: 'Ay isigi altinda sakince akan, yumusak tonlu bir gece masali.',
    categories: ['Gece', 'Huzur', 'Dogal', 'Uyku'],
    relatedStoryIds: ['ay-isigi-ormani', 'uyku-yolculugu', 'ruzgarin-sarkisi'],
  ),
  'minik-ejderha': StoryCatalogEntry(
    id: 'minik-ejderha',
    title: 'Minik Ejderha',
    imagePath: defaultStoryImagePath,
    summary: 'Cesaretini yeni kesfeden minik bir ejderhayla sicak bir seruven.',
    categories: ['Cesaret', 'Fantastik', 'Dostluk', 'Macera'],
    relatedStoryIds: ['bulut-sarayi', 'isikli-kitap', 'minik-dostlar'],
  ),
  'bulut-sarayi-trial': StoryCatalogEntry(
    id: 'bulut-sarayi-trial',
    title: 'Bulut Sarayi',
    imagePath: defaultStoryImagePath,
    summary: 'Bulut sarayinin kapilarini aralayan kisa bir deneme bolumu.',
    categories: ['Deneme', 'Fantastik', 'Hayal', 'Masalsi'],
    relatedStoryIds: ['bulut-sarayi', 'isikli-kitap', 'minik-ejderha'],
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
