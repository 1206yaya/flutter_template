import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/signin_screen.dart';
import '../features/home/home_screen.dart';
import 'go_router_refresh_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRouter { checklist }

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable:
          // GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
          GoRouterRefreshStream(authRepository.authStateChanges()),
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;

        final path = state.uri.path;
        if (path == '/terms-of-service' || path == '/privacy-policy') {
          return null;
        }
        if (!isLoggedIn) {
          return '/signin';
        } else if (path == '/signin') {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/signin',
          name: 'signin',
          builder: (context, state) => const SignInScreen(),
        ),
      ]);
}
