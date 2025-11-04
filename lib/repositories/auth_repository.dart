import '../models/app_user.dart';
import '../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _service;
  AuthRepository(this._service);

  Stream<AppUser?> authStateChanges() => _service.authStateChanges();

  Future<AppUser?> signInWithGoogle() => _service.signInWithGoogle();
  Future<AppUser?> signInWithFacebook() => _service.signInWithFacebook();
  Future<AppUser?> signInWithEmail(String email, String password) => _service.signInWithEmail(email, password);
  Future<AppUser?> registerWithEmail(String email, String password, String displayName) => _service.registerWithEmail(email, password, displayName);
  Future<void> signOut() => _service.signOut();
}
