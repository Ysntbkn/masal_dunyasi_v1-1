import '../models/interactive_story_scene.dart';

const String interactivePrincessRescueTitle = 'Prensesi Kurtar';
const String interactiveLostCrownTitle = 'Kayip Tac';

const List<InteractiveStoryScene> _interactivePrincessRescueScenes = [
  InteractiveStoryScene(
    id: 'rescue_story_start',
    type: InteractiveSceneType.story,
    title: 'Zindana Yolculuk',
    text:
        'Mia, kalenin eski zindaninda mahsur kalan prensesi kurtarmak icin senden yardim istiyor.',
    backgroundAsset:
        'asset/sleep page/freepik__a-magical-fairytale-night-scene-a-little-dreamer-s__95193.png',
  ),
  InteractiveStoryScene(
    id: 'rescue_find_key',
    type: InteractiveSceneType.interaction,
    title: 'Anahtari Bul',
    text: 'Parlayan anahtari bul ve kapiyi acmak icin yanina al.',
    backgroundAsset:
        'asset/sleep page/freepik__a-magical-fairytale-night-scene-a-little-dreamer-s__95193.png',
    objects: [
      InteractiveObject(
        id: 'golden_key',
        label: 'Altin Anahtar',
        iconName: 'key',
        actionType: InteractiveObjectActionType.collect,
        positionX: 0.73,
        positionY: 0.79,
        width: 58,
        height: 58,
        anchor: InteractiveObjectAnchor.bottomCenter,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'rescue_open_door',
    type: InteractiveSceneType.interaction,
    title: 'Eski Kapi',
    text:
        'Sihirli kelimeyi soyle, sonra kapiya dokunarak kapinin acilmasini sagla.',
    backgroundAsset: 'asset/kategoriler page/arkaplan_optimized.jpg',
    objects: [
      InteractiveObject(
        id: 'ancient_door',
        label: 'Kapi',
        iconName: 'door',
        actionType: InteractiveObjectActionType.open,
        positionX: 0.5,
        positionY: 0.77,
        width: 92,
        height: 128,
        anchor: InteractiveObjectAnchor.bottomCenter,
      ),
    ],
    checkpoint: UnlockCheckpoint(
      requiredKeyword: 'isik',
      instructionText: 'Kapiyi acmak icin sihirli kelimeyi soyle: ISIK',
      hintText: 'Geceleri gokyuzunde parlayan sey...',
    ),
  ),
  InteractiveStoryScene(
    id: 'rescue_reward',
    type: InteractiveSceneType.reward,
    title: 'Mutlu Son',
    text: 'Kapi acildi, prenses ozgurlugune kavustu. Harika is cikardin!',
    backgroundAsset: 'asset/rozet page/arkaplan_optimized.jpg',
  ),
];

const List<InteractiveStoryScene> _interactiveLostCrownScenes = [
  InteractiveStoryScene(
    id: 'lost_crown_story_1',
    type: InteractiveSceneType.story,
    title: 'Kraliyet Toreni',
    text:
        'Prenses Mia bugun ilk kez halkin karsisina cikmak icin hazirlaniyor.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_1.png',
  ),
  InteractiveStoryScene(
    id: 'lost_crown_story_2',
    type: InteractiveSceneType.story,
    title: 'Bos Tac Kutusu',
    text:
        'Mia tacini takmak ister ama kutu bos gorunur. Icinde sadece parlayan kucuk bir iz vardir.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_2.png',
  ),
  InteractiveStoryScene(
    id: 'lost_crown_story_3',
    type: InteractiveSceneType.story,
    title: 'Saray Sercesi',
    text:
        'Serce, sihirli tacin uc parcaya ayrildigini soyler. Parcalar odada, koridorda ve ayna salonunda saklidir.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_3.png',
  ),
  InteractiveStoryScene(
    id: 'lost_crown_room_search',
    type: InteractiveSceneType.interaction,
    title: 'Odadaki Ilk Isik',
    text:
        'Perdeye, oyuncaklara ve yatagin yanina bak. Parlayan ilk tac parcasi odada sakli.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum 4 oda.png',
    objects: [
      InteractiveObject(
        id: 'first_crown_piece',
        label: '1. Tac Parcasi',
        iconName: 'star',
        actionType: InteractiveObjectActionType.collect,
        positionX: 0.77,
        positionY: 0.72,
        width: 62,
        height: 62,
        anchor: InteractiveObjectAnchor.bottomCenter,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'lost_crown_story_5',
    type: InteractiveSceneType.story,
    title: 'Koridora Uzanan Isik',
    text:
        'Ilk parca bulununca odadaki isik koridora dogru uzanir. Mia ve cocuk isigi takip eder.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_2.png',
  ),
  InteractiveStoryScene(
    id: 'lost_crown_drag_boxes',
    type: InteractiveSceneType.drag,
    title: 'Kapali Koridor',
    text:
        'Eski oyuncak sandiklari yolu kapatmis. Sandiklari kenara surukleyip gecis yolunu ac.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_6.png',
    objects: [
      InteractiveObject(
        id: 'corridor_box_stack',
        label: 'Sandiklar',
        assetIcon: 'asset/interactive/kayip_tac/bolum_6 engel_interaktif.png',
        actionType: InteractiveObjectActionType.drag,
        positionX: 0.5,
        positionY: 0.9,
        width: 338,
        height: 273,
        anchor: InteractiveObjectAnchor.bottomCenter,
        isDraggable: true,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'lost_crown_second_piece',
    type: InteractiveSceneType.interaction,
    title: 'Koridordaki Parca',
    text:
        'Yol acilinca ikinci tac parcasi sandiklarin arkasinda parlamaya baslar. Dokunup al.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_4.png',
    objects: [
      InteractiveObject(
        id: 'second_crown_piece',
        label: '2. Tac Parcasi',
        iconName: 'star',
        actionType: InteractiveObjectActionType.collect,
        positionX: 0.54,
        positionY: 0.75,
        width: 62,
        height: 62,
        anchor: InteractiveObjectAnchor.bottomCenter,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'lost_crown_story_8',
    type: InteractiveSceneType.story,
    title: 'Ayna Salonuna Dogru',
    text: 'Iki parca birlesince tacin son isigi ayna salonuna yansir.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_3.png',
  ),
  InteractiveStoryScene(
    id: 'lost_crown_mirror_piece',
    type: InteractiveSceneType.interaction,
    title: 'Aynadaki Son Parca',
    text:
        'Ayna salonunda son parca yansimada gizli. Aynaya dokun, parca gorunsun ve onu al.',
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_3.png',
    objects: [
      // Ayrica ayna salonu icin ozel PNG gelirse burada `assetIcon` ile dogrudan kullanilabilir.
      InteractiveObject(
        id: 'mirror_piece',
        label: '3. Tac Parcasi',
        iconName: 'mirror',
        actionType: InteractiveObjectActionType.reward,
        positionX: 0.5,
        positionY: 0.46,
        width: 86,
        height: 110,
        anchor: InteractiveObjectAnchor.center,
      ),
    ],
  ),
  InteractiveStoryScene(
    id: 'lost_crown_reward',
    type: InteractiveSceneType.reward,
    title: 'Tac Tamamlandi',
    text:
        'Uc parca birlesir, tac yeniden tamamlanir. Mia torene yetisir ve sana Kraliyet Yardimcisi rozeti verir.',
    // Final icin ayri bir PNG eklenirse bu sahnede `backgroundAsset` guncellenebilir.
    backgroundAsset: 'asset/interactive/kayip_tac/bolum_1.png',
  ),
];

List<InteractiveStoryScene> buildInteractivePrincessRescueScenes() {
  return _cloneScenes(_interactivePrincessRescueScenes);
}

List<InteractiveStoryScene> buildInteractiveLostCrownScenes() {
  return _cloneScenes(_interactiveLostCrownScenes);
}

List<InteractiveStoryScene> _cloneScenes(List<InteractiveStoryScene> scenes) {
  return scenes
      .map(
        (scene) => scene.copyWith(
          objects: scene.objects.map((object) => object.copyWith()).toList(),
          checkpoint: scene.checkpoint?.copyWith(),
        ),
      )
      .toList();
}
