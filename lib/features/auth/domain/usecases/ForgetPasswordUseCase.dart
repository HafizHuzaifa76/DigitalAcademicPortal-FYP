// lib/features/auth/domain/usecases/forget_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../repositories/AuthRepository.dart';

class ForgetPasswordUseCase implements UseCase<String, String> {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  @override
  Future<Either<Fail, String>> execute(String email) async {
    return await repository.forgetPassword(email);
  }
}
