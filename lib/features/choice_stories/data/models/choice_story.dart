class ChoiceStory {
  const ChoiceStory({
    required this.id,
    required this.title,
    required this.description,
    required this.coverAsset,
    required this.scenes,
  });

  final String id;
  final String title;
  final String description;
  final String coverAsset;
  final List<ChoiceStoryScene> scenes;
}

class ChoiceStoryScene {
  const ChoiceStoryScene({
    required this.id,
    required this.title,
    required this.text,
    required this.imageAsset,
    this.options = const <ChoiceOption>[],
    this.isEnding = false,
  });

  final String id;
  final String title;
  final String text;
  final String? imageAsset;
  final List<ChoiceOption> options;
  final bool isEnding;
}

class ChoiceOption {
  const ChoiceOption({required this.text, required this.nextSceneId});

  final String text;
  final String nextSceneId;
}
