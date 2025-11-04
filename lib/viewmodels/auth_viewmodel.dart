import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../models/app_user.dart';

class AuthViewModel extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _repo;
  late final Stream<AppUser?> _authStream;
  AuthViewModel(this._repo) : super(const AsyncValue.loading()) {
    _authStream = _repo.authStateChanges();
    _authStream.listen((u) {
      state = AsyncValue.data(u);
    }, onError: (err, st) {
      state = AsyncValue.error(err, st);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final u = await _repo.signInWithGoogle();
      state = AsyncValue.data(u);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithFacebook() async {
    state = const AsyncValue.loading();
    try {
      final u = await _repo.signInWithFacebook();
      state = AsyncValue.data(u);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final u = await _repo.signInWithEmail(email, password);
      state = AsyncValue.data(u);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> registerWithEmail(String email, String password, String displayName) async {
    state = const AsyncValue.loading();
    try {
      final u = await _repo.registerWithEmail(email, password, displayName);
      state = AsyncValue.data(u);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }
}
