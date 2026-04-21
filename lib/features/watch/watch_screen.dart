import 'package:flutter/material.dart';

import '../../shared/widgets/section_scaffold.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: '\u0130zle',
      children: [
        RoundedActionCard(
          title: 'Yak\u0131nda',
          subtitle: 'Animasyonlu masal videolar\u0131 burada olacak.',
          icon: Icons.play_circle_fill_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}
