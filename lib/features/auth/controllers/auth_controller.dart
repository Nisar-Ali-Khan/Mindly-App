import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../services/auth_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController(
    ref.watch(authServiceProvider),
    ref.watch(authRepositoryProvider),
  );
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;
  final AuthRepository _authRepository;

  AuthController(this._authService, this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        try {
          final userProfile = await _authRepository.getUserProfile(user.uid);
          state = AsyncValue.data(userProfile ?? _createGuestModel(user.uid));
        } catch (_) {
          state = AsyncValue.data(_createGuestModel(user.uid));
        }
      } else {
        // Keep guest session if active, otherwise set null
        if (state.value?.id.startsWith('guest_') ?? false) {
          return;
        }
        state = const AsyncValue.data(null);
      }
    });
  }

  static UserModel _createGuestModel(String id) {
    return UserModel(
      id: id,
      email: 'guest@mindly.app',
      displayName: 'Guest User',
      role: UserRole.teen,
      createdAt: DateTime.now(),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authService.signUp(email, password);
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
      );
      await _authRepository.createUserProfile(userModel);
      state = AsyncValue.data(userModel);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authService.signIn(email, password);
      final userProfile = await _authRepository.getUserProfile(userCredential.user!.uid);
      state = AsyncValue.data(userProfile ?? _createGuestModel(userCredential.user!.uid));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authService.signInAnonymously();
      final uid = userCredential.user!.uid;
      
      var userProfile = await _authRepository.getUserProfile(uid);
      if (userProfile == null) {
        userProfile = _createGuestModel(uid);
        await _authRepository.createUserProfile(userProfile).catchError((_) {});
      }
      state = AsyncValue.data(userProfile);
    } catch (e) {
      debugPrint("Firebase Auth Anonymous failed ($e). Falling back to Instant Local Guest Session.");
      // Fallback to Instant Guest Mode so app NEVER fails for teenagers!
      final guestUid = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final guestProfile = _createGuestModel(guestUid);
      state = AsyncValue.data(guestProfile);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (_) {}
    state = const AsyncValue.data(null);
  }
}
