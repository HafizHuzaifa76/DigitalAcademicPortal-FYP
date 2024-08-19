// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Fail, void>> login(String email, String password);
}
