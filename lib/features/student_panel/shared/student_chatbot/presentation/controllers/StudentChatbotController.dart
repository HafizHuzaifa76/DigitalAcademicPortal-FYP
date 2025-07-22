import 'dart:async';
import 'package:get/get.dart';
import '../../domain/entities/ChatMessageEntity.dart';
import '../../domain/entities/StudentFAQ.dart';
import '../../domain/usecases/SendStudentChatMessageUseCase.dart';
import '../../domain/usecases/GetStudentFAQsUseCase.dart';

class StudentChatbotController extends GetxController {
  final SendStudentChatMessageUseCase sendMessageUseCase;
  final GetStudentFAQsUseCase getFAQsUseCase;

  StudentChatbotController({
    required this.sendMessageUseCase,
    required this.getFAQsUseCase,
  });

  var messages = <ChatMessageEntity>[].obs;
  var faqs = <StudentFAQ>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    faqs.value = getFAQsUseCase();
  }

  Future<void> sendMessage(String text) async {
    isLoading.value = true;
    messages.add(ChatMessageEntity(
        text: text, isFromUser: true, timestamp: DateTime.now()));
    try {
      final response = await sendMessageUseCase(text, faqs);
      messages.add(response);
    } catch (e) {
      messages.add(ChatMessageEntity(
          text: 'Sorry, something went wrong.',
          isFromUser: false,
          timestamp: DateTime.now()));
    } finally {
      isLoading.value = false;
    }
  }
}
