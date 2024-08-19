// lib/features/auth/presentation/bindings/auth_binding.dart
import 'package:get/get.dart';

import '../../data/datasources/AuthDatasource.dart';
import '../../data/repositories/AuthRepositoryImpl.dart';
import '../../domain/repositories/AuthRepository.dart';
import '../../domain/usecases/LoginUsecase.dart';
import '../controllers/AuthController.dart';

class AuthBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => AuthController(loginUsecase: Get.find()));
    // Get.lazyPut<AuthRepository>(() => AuthRepository());
    // Get.lazyPut(()=>  AuthRepository);
  }
}
