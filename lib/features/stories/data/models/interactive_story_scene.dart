enum InteractiveObjectActionType { collect, open, reward }

class InteractiveStoryScene {
  const InteractiveStoryScene({
    required this.id,
    required this.title,
    required this.text,
    this.backgroundAsset,
    this.objects = const <InteractiveObject>[],
    this.checkpoint,
  });

  final String id;
  final String title;
  final String text;
  final String? backgroundAsset;
  final List<InteractiveObject> objects;
  final UnlockCheckpoint? checkpoint;

  InteractiveStoryScene copyWith({
    String? id,
    String? title,
    String? text,
    String? backgroundAsset,
    List<InteractiveObject>? objects,
    UnlockCheckpoint? checkpoint,
  }) {
    return InteractiveStoryScene(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      objects: objects ?? this.objects,
      checkpoint: checkpoint ?? this.checkpoint,
    );
  }
}

class InteractiveObject {
  const InteractiveObject({
    required this.id,
    required this.label,
    this.assetIcon,
    this.iconName,
    required this.actionType,
    this.isCollected = false,
    required this.positionX,
    required this.positionY,
  });

  final String id;
  final String label;
  final String? assetIcon;
  final String? iconName;
  final InteractiveObjectActionType actionType;
  final bool isCollected;
  final double positionX;
  final double positionY;

  InteractiveObject copyWith({
    String? id,
    String? label,
    String? assetIcon,
    String? iconName,
    InteractiveObjectActionType? actionType,
    bool? isCollected,
    double? positionX,
    double? positionY,
  }) {
    return InteractiveObject(
      id: id ?? this.id,
      label: label ?? this.label,
      assetIcon: assetIcon ?? this.assetIcon,
      iconName: iconName ?? this.iconName,
      actionType: actionType ?? this.actionType,
      isCollected: isCollected ?? this.isCollected,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
    );
  }
}

class UnlockCheckpoint {
  const UnlockCheckpoint({
    required this.requiredKeyword,
    required this.instructionText,
    required this.hintText,
    this.isUnlocked = false,
  });

  final String requiredKeyword;
  final String instructionText;
  final String hintText;
  final bool isUnlocked;

  UnlockCheckpoint copyWith({
    String? requiredKeyword,
    String? instructionText,
    String? hintText,
    bool? isUnlocked,
  }) {
    return UnlockCheckpoint(
      requiredKeyword: requiredKeyword ?? this.requiredKeyword,
      instructionText: instructionText ?? this.instructionText,
      hintText: hintText ?? this.hintText,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
