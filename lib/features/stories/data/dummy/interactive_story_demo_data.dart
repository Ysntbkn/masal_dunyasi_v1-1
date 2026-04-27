import '../models/interactive_story_scene.dart';

const String interactivePrincessRescueTitle = 'Prensesi Zindandan Kurtar';

const List<InteractiveStoryScene> _interactivePrincessRescueScenes = [
  InteractiveStoryScene(
    id: 'dungeon_start',
    title: 'Zindan',
    text: 'Prenses karanlık zindanda yardım bekliyordu.',
    backgroundAsset:
        'asset/sleep page/freepik__a-magical-fairytale-night-scene-a-little-dreamer-s__95193.png',
    objects: [
      InteractiveObject(
        id: 'golden_key',
        label: 'Anahtar',
        iconName: 'key',
        actionType: InteractiveObjectActionType.collect,
        positionX: 0.68,
        positionY: 0.18,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'ancient_door',
    title: 'Eski Kapı',
    text: 'Karşında eski bir kapı vardı.',
    backgroundAsset: 'asset/kategoriler page/arkaplan_optimized.jpg',
    objects: [
      InteractiveObject(
        id: 'ancient_door',
        label: 'Kapı',
        iconName: 'door',
        actionType: InteractiveObjectActionType.open,
        positionX: 0.42,
        positionY: 0.14,
      ),
    ],
    checkpoint: UnlockCheckpoint(
      requiredKeyword: 'ışık',
      instructionText: 'Kapıyı açmak için sihirli kelimeyi söyle: IŞIK',
      hintText: 'Gökyüzünde parlayan şey gibi…',
    ),
  ),
  InteractiveStoryScene(
    id: 'starry_path',
    title: 'Yıldızlı Yol',
    text: 'Kapı açıldı ve yıldızlı bir yol ortaya çıktı.',
    backgroundAsset: 'asset/rozet page/arkaplan_optimized.jpg',
    objects: [
      InteractiveObject(
        id: 'guiding_star',
        label: 'Yıldız',
        iconName: 'star',
        actionType: InteractiveObjectActionType.reward,
        positionX: 0.56,
        positionY: 0.10,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'freedom',
    title: 'Mutlu Son',
    text: 'Prenses özgürlüğüne kavuştu. Harika iş!',
    backgroundAsset:
        'asset/books/freepik_cute-little-bear-standing_2791150604.png',
  ),
];

List<InteractiveStoryScene> buildInteractivePrincessRescueScenes() {
  return _interactivePrincessRescueScenes
      .map(
        (scene) => scene.copyWith(
          objects: scene.objects.map((object) => object.copyWith()).toList(),
          checkpoint: scene.checkpoint?.copyWith(),
        ),
      )
      .toList();
}
