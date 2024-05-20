import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../environment/src/flavor_provider.dart';
import '../app/data/package_info_provider.dart';
import 'data/auth_repository.dart';
import 'login_form.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    final packageInfo = ref.watch(packageInfoProvider);

    final ThemeData theme = Theme.of(context);

    final googleSignIn = ref.read(googleSignInProvider);

    Future<User?> signInWithGoogle() async {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return authResult.user;
      }
      return null;
    }

    void showButtonPressDialog(BuildContext context, String provider) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider Button Pressed!'),
          backgroundColor: Colors.black26,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          packageInfo.appName,
          style: const TextStyle(fontSize: 36, fontFamily: 'PoetsenOne'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Text(
                    'Flutter Riverpod Firebase',
                    style: theme.textTheme.headlineMedium,
                  )),
            ),
            SignInButton(
              Buttons.google,
              text: "Googleで続ける",
              onPressed: () async {
                final user = await signInWithGoogle();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width *
                    0.08, // 4% of screen width
                vertical: 12,
              ),
            ),
            const Gap(48),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: consentMessage(context),
            ),
          ],
        ),
      ),
    );
  }
}

RichText consentMessage(BuildContext context) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: Theme.of(context).textTheme.bodyMedium,
      children: [
        const TextSpan(
          text: '登録すると',
        ),
        TextSpan(
          text: '利用規約',
          style: const TextStyle(color: Colors.green),
          recognizer: TapGestureRecognizer()
            ..onTap = () => context.goNamed("terms-of-service"),
        ),
        const TextSpan(
          text: 'と',
        ),
        TextSpan(
          text: 'プライバシーポリシー',
          style: const TextStyle(color: Colors.green),
          recognizer: TapGestureRecognizer()
            ..onTap = () => context.goNamed("privacy-policy"),
        ),
        const TextSpan(
          text: 'に同意したものとみなされます',
        ),
      ],
    ),
  );
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
