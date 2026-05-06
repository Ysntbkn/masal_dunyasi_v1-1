enum InteractiveSceneType { story, interaction, drag, reward }

enum InteractiveObjectAnchor {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum InteractiveObjectActionType { collect, open, reward, drag }

class InteractiveStoryScene {
  const InteractiveStoryScene({
    required this.id,
    required this.type,
    required this.title,
    required this.text,
    this.backgroundAsset,
    this.objects = const <InteractiveObject>[],
    this.checkpoint,
  });

  final String id;
  final InteractiveSceneType type;
  final String title;
  final String text;
  final String? backgroundAsset;
  final List<InteractiveObject> objects;
  final UnlockCheckpoint? checkpoint;

  InteractiveStoryScene copyWith({
    String? id,
    InteractiveSceneType? type,
    String? title,
    String? text,
    String? backgroundAsset,
    List<InteractiveObject>? objects,
    UnlockCheckpoint? checkpoint,
  }) {
    return InteractiveStoryScene(
      id: id ?? this.id,
      type: type ?? this.type,
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
    required this.positionX,
    required this.positionY,
    this.width = 72,
    this.height = 72,
    this.anchor = InteractiveObjectAnchor.center,
    required this.actionType,
    this.isCollected = false,
    this.isDraggable = false,
  });

  final String id;
  final String label;
  final String? assetIcon;
  final String? iconName;
  final double positionX;
  final double positionY;
  final double width;
  final double height;
  final InteractiveObjectAnchor anchor;
  final InteractiveObjectActionType actionType;
  final bool isCollected;
  final bool isDraggable;

  InteractiveObject copyWith({
    String? id,
    String? label,
    String? assetIcon,
    String? iconName,
    double? positionX,
    double? positionY,
    double? width,
    double? height,
    InteractiveObjectAnchor? anchor,
    InteractiveObjectActionType? actionType,
    bool? isCollected,
    bool? isDraggable,
  }) {
    return InteractiveObject(
      id: id ?? this.id,
      label: label ?? this.label,
      assetIcon: assetIcon ?? this.assetIcon,
      iconName: iconName ?? this.iconName,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      width: width ?? this.width,
      height: height ?? this.height,
      anchor: anchor ?? this.anchor,
      actionType: actionType ?? this.actionType,
      isCollected: isCollected ?? this.isCollected,
      isDraggable: isDraggable ?? this.isDraggable,
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
