
import 'package:get/get.dart';

import '../../data/datasources/TemplateRemoteDataSource.dart';
import '../../data/repositories/TemplateRepositoryImpl.dart';
import '../../domain/repositories/TemplateRepository.dart';
import '../../domain/usecases/AddTemplateUseCase.dart';
import '../../domain/usecases/AllTemplateUseCase.dart';
import '../../domain/usecases/DeleteTemplateUseCase.dart';
import '../../domain/usecases/EditTemplateUseCase.dart';
import '../controllers/TemplateController.dart';

class TemplateBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TemplateRemoteDataSource>(() => TemplateRemoteDataSourceImpl());
    Get.lazyPut<TemplateRepository>(() => TemplateRepositoryImpl(templateRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllTemplatesUseCase(Get.find()));
    Get.lazyPut(() => AddTemplateUseCase(Get.find()));
    Get.lazyPut(() => EditTemplateUseCase(Get.find()));
    Get.lazyPut(() => DeleteTemplateUseCase(Get.find()));
    Get.lazyPut(() => TemplateController(addTemplateUseCase: Get.find(), deleteTemplateUseCase: Get.find(), editTemplateUseCase: Get.find(), allTemplatesUseCase: Get.find()));
  }

}