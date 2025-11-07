import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    });
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final u = cred.user!;
    return AppUser(
      uid: u.uid,
      displayName: u.displayName,
      email: u.email,
      photoUrl: u.photoURL,
    );
  }

  Future<AppUser?> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user!.updateDisplayName(displayName);
    await cred.user!.reload(); // ✅ REQUIRED FIX

    final user = _auth.currentUser!;

    return AppUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  Future<AppUser?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    final u = userCred.user!;
    return AppUser(
      uid: u.uid,
      displayName: u.displayName,
      email: u.email,
      photoUrl: u.photoURL,
    );
  }

  Future<AppUser?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) return null;

    final AccessToken accessToken = result.accessToken!;
    final OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final u = userCred.user!;

    return AppUser(
      uid: u.uid,
      displayName: u.displayName,
      email: u.email,
      photoUrl: u.photoURL,
    );
  }

  Future<void> signOut() => _auth.signOut();
}
