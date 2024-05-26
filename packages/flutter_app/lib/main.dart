import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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

Future<void> useEmulator() async {
  //! エミュレーターとの接続がおかしい時は、再ログインする
  //* 外部デバイスからエミュレーターに接続するときは、ネットワークを有線ではなく確実にWi-Fiにしておく
  // ip route get 8.8.8.8 | head -1 | awk '{print $7}'
  // ipconfig getifaddr en0
  const defaultHost = "192.168.11.7";
  const VAR1 = String.fromEnvironment('VAR1');
  print("defaultHost $defaultHost"); //
  print("VAR1 $VAR1"); //
  var configHost = Platform.isAndroid ? '10.0.2.2' : defaultHost;
  var host = configHost;

  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
  FirebaseFirestore.instance.settings = Settings(
      host: '$host:8080', sslEnabled: false, persistenceEnabled: false);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final flavor = Flavor.values.byName(const String.fromEnvironment('flavor'));
  const isEmulator = bool.fromEnvironment('IS_EMULATOR');
  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));

  initializeCrashlytics();

  if (isEmulator) {
    await useEmulator();
  }

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

void initializeCrashlytics() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  const fatalError = true;

  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // "Fatal" exceptionの記録
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // "Non-fatal" exceptionの記録
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  // Flutterフレームワークで処理されない非同期エラーをキャッチ
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // "Fatal" exceptionの記録
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // "Non-fatal" exceptionの記録
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}
