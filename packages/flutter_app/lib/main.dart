import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:someapp/environment/environment.dart';
import 'package:someapp/features/app/data/package_info_provider.dart';

import 'environment/src/firebase_options.dart';
import 'environment/src/flavor_provider.dart';
import 'routing/app_router.dart';
import 'features/app/data/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));

  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));
  final packageInfo = await PackageInfo.fromPlatform();
  runApp(ProviderScope(overrides: [
    flavorProvider.overrideWithValue(flavor),
    packageInfoProvider.overrideWithValue(packageInfo)
  ], child: const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
      routerConfig: goRouter,
      // /Users/zak/ghq/github.com/rydmike/theme_demo
      theme: ref.watch(appThemeProvider),
      themeMode: ThemeMode.dark,
    );
  }
}
