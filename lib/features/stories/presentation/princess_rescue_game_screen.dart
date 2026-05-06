import 'package:flutter/widgets.dart';

import '../data/dummy/interactive_story_demo_data.dart';
import 'interactive_story_screen.dart';

class PrincessRescueGameScreen extends StatelessWidget {
  const PrincessRescueGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveStoryScreen(
      storyTitle: interactivePrincessRescueTitle,
      scenes: buildInteractivePrincessRescueScenes(),
    );
  }
}
