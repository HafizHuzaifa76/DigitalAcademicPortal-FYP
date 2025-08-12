import 'package:get/get.dart';
import '../../data/datasources/StudentChatbotRemoteDataSource.dart';
import '../../data/datasources/StudentChatbotFAQDataSource.dart';
import '../../data/repositories/StudentChatbotRepositoryImpl.dart';
import '../../domain/repositories/StudentChatbotRepository.dart';
import '../../domain/usecases/SendStudentChatMessageUseCase.dart';
import '../../domain/usecases/GetStudentFAQsUseCase.dart';
import '../controllers/StudentChatbotController.dart';

class StudentChatbotBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: Replace with your actual OpenAI API key
    const openAIApiKey = 'AIzaSyCwMqs2oeKcpxTlDiOyC7zmvAOiF07KMQE';
    Get.lazyPut(
        () => StudentChatbotRemoteDataSource(openAIApiKey: openAIApiKey));
    Get.lazyPut(() => StudentChatbotFAQDataSource());
    Get.lazyPut<StudentChatbotRepository>(() => StudentChatbotRepositoryImpl(
          remoteDataSource: Get.find(),
          faqDataSource: Get.find(),
        ));
    Get.lazyPut(() => SendStudentChatMessageUseCase(Get.find()));
    Get.lazyPut(() => GetStudentFAQsUseCase(Get.find()));
    Get.lazyPut(() => StudentChatbotController(
          sendMessageUseCase: Get.find(),
          getFAQsUseCase: Get.find(),
        ));
  }
}
