import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  // final means the value can't be changed after it's initialized
  final AuthRepository _authRepository;
  final Ref _ref;
  // the constructor is a special function that is called whenever a new instance of a class `AuthController` is created
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // initially not loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false; // loading is done
    // l means the left side of the Either which is the failure side
    // r (userModel) means the right side of the Either which is the success side
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
