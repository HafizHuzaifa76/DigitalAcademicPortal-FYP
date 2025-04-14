// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';

import '../../domain/repositories/AuthRepository.dart';
import '../datasources/AuthDatasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, String>> login(String email, String password) async {
    try {
      return Right(await remoteDataSource.login(email, password));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}
