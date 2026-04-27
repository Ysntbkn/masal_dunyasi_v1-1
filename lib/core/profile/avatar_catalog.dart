class AppAvatar {
  const AppAvatar({
    required this.id,
    required this.label,
    required this.imagePath,
  });

  final String id;
  final String label;
  final String imagePath;
}

const appAvatars = <AppAvatar>[
  AppAvatar(
    id: 'prenses',
    label: 'Avatar 1',
    imagePath: 'asset/avatar page/1.png',
  ),
  AppAvatar(
    id: 'kirmizi-baslik',
    label: 'Avatar 2',
    imagePath: 'asset/avatar page/2.png',
  ),
  AppAvatar(
    id: 'buyucu',
    label: 'Avatar 3',
    imagePath: 'asset/avatar page/3.png',
  ),
  AppAvatar(
    id: 'gezgin',
    label: 'Avatar 4',
    imagePath: 'asset/avatar page/4.png',
  ),
  AppAvatar(
    id: 'dedektif',
    label: 'Avatar 5',
    imagePath: 'asset/avatar page/5.png',
  ),
  AppAvatar(
    id: 'denizci',
    label: 'Avatar 6',
    imagePath: 'asset/avatar page/6.png',
  ),
];

AppAvatar appAvatarFor(String avatarId) {
  return appAvatars.firstWhere(
    (avatar) => avatar.id == avatarId,
    orElse: () => appAvatars.first,
  );
}
