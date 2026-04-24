class BadgeDefinition {
  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.assetPath,
  });

  final String id;
  final String title;
  final String assetPath;
}

const List<BadgeDefinition> badgeCatalog = [
  BadgeDefinition(
    id: 'ilk_masalim',
    title: '\u0130lk Masal\u0131m',
    assetPath: 'asset/rozetler/ilk masal\u0131m.png',
  ),
  BadgeDefinition(
    id: 'uyku_oncesi_kahramani',
    title: 'Uyku \u00d6ncesi Kahraman\u0131',
    assetPath: 'asset/rozetler/uyku \u00f6ncesi kahraman\u0131.png',
  ),
  BadgeDefinition(
    id: 'seri_okuyucu',
    title: 'Seri Okuyucu',
    assetPath: 'asset/rozetler/seri okuyucu.png',
  ),
  BadgeDefinition(
    id: 'hayal_gucu_ustasi',
    title: 'Hayal G\u00fcc\u00fc Ustas\u0131',
    assetPath: 'asset/rozetler/hayal g\u00fcc\u00fc ustas\u0131.png',
  ),
  BadgeDefinition(
    id: 'kitap_kurdu',
    title: 'Kitap Kurdu',
    assetPath: 'asset/rozetler/kitap kurdu.png',
  ),
  BadgeDefinition(
    id: 'masal_krali',
    title: 'Masal Kral\u0131',
    assetPath: 'asset/rozetler/masal kral\u0131.png',
  ),
  BadgeDefinition(
    id: 'hayvan_dostu',
    title: 'Hayvan Dostu',
    assetPath: 'asset/rozetler/hayvan dostu.png',
  ),
  BadgeDefinition(
    id: 'hizli_okuyucu',
    title: 'H\u0131zl\u0131 Okuyucu',
    assetPath: 'asset/rozetler/h\u0131zl\u0131 okuyucu.png',
  ),
  BadgeDefinition(
    id: 'gun_7',
    title: '7 G\u00fcn',
    assetPath: 'asset/rozetler/7 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'favori_avcisi',
    title: 'Favori Avc\u0131s\u0131',
    assetPath: 'asset/rozetler/favori avc\u0131s\u0131.png',
  ),
  BadgeDefinition(
    id: 'gun_15',
    title: '15 G\u00fcn',
    assetPath: 'asset/rozetler/15 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_30',
    title: '30 G\u00fcn',
    assetPath: 'asset/rozetler/30 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_60',
    title: '60 G\u00fcn',
    assetPath: 'asset/rozetler/60 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_100',
    title: '100 G\u00fcn',
    assetPath: 'asset/rozetler/100 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_150',
    title: '150 G\u00fcn',
    assetPath: 'asset/rozetler/150 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_200',
    title: '200 G\u00fcn',
    assetPath: 'asset/rozetler/200 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_300',
    title: '300 G\u00fcn',
    assetPath: 'asset/rozetler/300 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_500',
    title: '500 G\u00fcn',
    assetPath: 'asset/rozetler/500 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_1000',
    title: '1000 G\u00fcn',
    assetPath: 'asset/rozetler/1000 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_2000',
    title: '2000 G\u00fcn',
    assetPath: 'asset/rozetler/2000 g\u00fcn.png',
  ),
  BadgeDefinition(
    id: 'gun_5000',
    title: '5000 G\u00fcn',
    assetPath: 'asset/rozetler/5000 g\u00fcn.png',
  ),
];

const Map<int, String> activityDayBadgeIds = {
  7: 'gun_7',
  15: 'gun_15',
  30: 'gun_30',
  60: 'gun_60',
  100: 'gun_100',
  150: 'gun_150',
  200: 'gun_200',
  300: 'gun_300',
  500: 'gun_500',
  1000: 'gun_1000',
  2000: 'gun_2000',
  5000: 'gun_5000',
};

BadgeDefinition? badgeDefinitionById(String id) {
  for (final badge in badgeCatalog) {
    if (badge.id == id) return badge;
  }
  return null;
}
