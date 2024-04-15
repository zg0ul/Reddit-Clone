import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';

// We can use this typedef like FutureEither<UserModel> instead of Future<Either<Failure, UserModel>>
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<void>; // when there can be a failure but success doesn't return a value