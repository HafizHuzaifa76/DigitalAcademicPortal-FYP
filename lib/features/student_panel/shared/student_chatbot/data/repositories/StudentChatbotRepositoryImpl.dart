import '../../domain/entities/ChatMessageEntity.dart';
import '../../domain/entities/StudentFAQ.dart';
import '../../domain/repositories/StudentChatbotRepository.dart';
import '../datasources/StudentChatbotRemoteDataSource.dart';
import '../datasources/StudentChatbotFAQDataSource.dart';

class StudentChatbotRepositoryImpl implements StudentChatbotRepository {
  final StudentChatbotRemoteDataSource remoteDataSource;
  final StudentChatbotFAQDataSource faqDataSource;

  StudentChatbotRepositoryImpl({
    required this.remoteDataSource,
    required this.faqDataSource,
  });

  @override
  Future<ChatMessageEntity> sendMessage(
      String message, List<StudentFAQ> faqs) async {
    // Build context string from FAQs
    String faqContext =
        faqs.map((faq) => 'Q: ${faq.question}\nA: ${faq.answer}').join('\n\n');
    String prompt =
        'You are a helpful student portal assistant. Use the following FAQs to answer as accurately as possible.\n\n$faqContext\n\nUser: $message';
    final response = await remoteDataSource.sendMessageToOpenAI(prompt);
    return ChatMessageEntity(
        text: response, isFromUser: false, timestamp: DateTime.now());
  }

  @override
  List<StudentFAQ> getFAQs() {
    return faqDataSource.getFAQs();
  }
}
