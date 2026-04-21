import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_router.dart';
import 'core/state/app_state.dart';
import 'firebase_options.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MasalDunyasiApp(),
    ),
  );
}

class MasalDunyasiApp extends StatelessWidget {
  const MasalDunyasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createAppRouter(context.read<AppState>());

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Masal Dünyası',
      theme: buildAppTheme(),
      routerConfig: router,
      builder: (context, child) {
        return AppRouteWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
