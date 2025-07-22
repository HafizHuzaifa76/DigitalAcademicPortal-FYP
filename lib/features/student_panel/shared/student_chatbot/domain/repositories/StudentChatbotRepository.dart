import 'dart:async';
import '../entities/ChatMessageEntity.dart';
import '../entities/StudentFAQ.dart';

abstract class StudentChatbotRepository {
  Future<ChatMessageEntity> sendMessage(String message, List<StudentFAQ> faqs);
  List<StudentFAQ> getFAQs();
}
