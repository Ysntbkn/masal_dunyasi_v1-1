import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      context.read<AppState>().completeOnboarding();
      context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final strings = AppStrings(state);
    final name = state.userName;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.cinnamon),
              const SizedBox(height: 24),
              Text(
                strings.welcome(name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 34,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                strings.welcomePreparing,
                style: const TextStyle(
                  fontFamily: null,
                  color: AppColors.lavender,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
