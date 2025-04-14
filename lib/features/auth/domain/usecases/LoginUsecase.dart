// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/auth/domain/entities/UserEntity.dart';

import '../repositories/AuthRepository.dart';

class LoginUseCase implements UseCase<String, User>{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Fail, String>> execute(User user) async {
    return await repository.login(user.email, user.password);
  }
  
}
