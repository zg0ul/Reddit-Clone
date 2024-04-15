import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  // final means the value can't be changed after it's initialized
  final persist _authRepository;
  // the constructor is a special function that is called whenever a new instance of a class `AuthController` is created
  AuthController({required persist authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    // l means the left side of the Either which is the failure side
    // r means the right side of the Either which is the success side
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}
