import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_back_button.dart';

class SectionScaffold extends StatelessWidget {
  const SectionScaffold({
    super.key,
    required this.title,
    required this.children,
    this.actions,
  });

  final String title;
  final List<Widget> children;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppBackButtonAppBarLeading.leadingWidth,
        leading: AppBackButtonAppBarLeading(
          onTap: () => Navigator.of(context).maybePop(),
        ),
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
          children: children,
        ),
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: const CircleAvatar(
          backgroundColor: AppColors.peach,
          foregroundColor: AppColors.cinnamon,
          child: Icon(Icons.auto_stories_rounded),
        ),
        title: Text(title, style: const TextStyle(fontFamily: null)),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: null)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class RoundedActionCard extends StatelessWidget {
  const RoundedActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.cinnamon.withValues(alpha: 0.12),
          foregroundColor: AppColors.cinnamon,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontFamily: null)),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: null)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
