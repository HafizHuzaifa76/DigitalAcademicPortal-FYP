import 'dart:async';
import '../entities/ChatMessageEntity.dart';
import '../entities/StudentFAQ.dart';
import '../repositories/StudentChatbotRepository.dart';

class SendStudentChatMessageUseCase {
  final StudentChatbotRepository repository;
  SendStudentChatMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(String message, List<StudentFAQ> faqs) {
    return repository.sendMessage(message, faqs);
  }
}
