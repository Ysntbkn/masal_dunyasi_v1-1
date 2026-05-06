import 'package:flutter/widgets.dart';

import '../data/dummy/interactive_story_demo_data.dart';
import 'interactive_story_screen.dart';

class RoyalDayStoryScreen extends StatelessWidget {
  const RoyalDayStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveStoryScreen(
      storyTitle: interactiveLostCrownTitle,
      scenes: buildInteractiveLostCrownScenes(),
    );
  }
}
