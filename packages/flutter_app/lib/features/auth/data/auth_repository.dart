import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final Ref ref;

  AuthRepository(this._auth, this._googleSignIn, this.ref);

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(
        (User? user) => user != null ? AppUser.fromFirebaseUser(user) : null);
  }

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  AppUser? _convertUser(User? user) =>
      user != null ? AppUser.fromFirebaseUser(user) : null;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      return authResult.user;
    }
    return null;
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    await user!.delete();
  }

  Future<void> signOut() async {
    final googleSignIn = ref.read(googleSignInProvider);
    await googleSignIn.signOut();
    // await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}

@riverpod
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  return GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
      // 'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final googleSignin = ref.read(googleSignInProvider);
  return AuthRepository(FirebaseAuth.instance, googleSignin, ref);
}
