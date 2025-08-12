// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Fail, String>> login(String email, String password);
  Future<Either<Fail, String>> forgetPassword(String email);
}
