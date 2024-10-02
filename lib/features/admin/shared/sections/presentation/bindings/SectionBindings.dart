
import 'package:get/get.dart';

import '../../data/datasources/SectionRemoteDataSource.dart';
import '../../data/repositories/SectionRepositoryImpl.dart';
import '../../domain/repositories/SectionRepository.dart';
import '../../domain/usecases/AddSectionUseCase.dart';
import '../../domain/usecases/AllSectionsUseCase.dart';
import '../../domain/usecases/DeleteSectionUseCase.dart';
import '../../domain/usecases/EditSectionUseCase.dart';
import '../controllers/SectionController.dart';

class SectionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SectionRemoteDataSource>(() => SectionRemoteDataSourceImpl());
    Get.lazyPut<SectionRepository>(() => SectionRepositoryImpl(sectionRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllSectionsUseCase(Get.find()));
    Get.lazyPut(() => AddSectionUseCase(Get.find()));
    Get.lazyPut(() => EditSectionUseCase(Get.find()));
    Get.lazyPut(() => DeleteSectionUseCase(Get.find()));
    Get.lazyPut(() => SectionController(addSectionUseCase: Get.find(), deleteSectionUseCase: Get.find(), editSectionUseCase: Get.find(), allSectionsUseCase: Get.find()));
  }

}