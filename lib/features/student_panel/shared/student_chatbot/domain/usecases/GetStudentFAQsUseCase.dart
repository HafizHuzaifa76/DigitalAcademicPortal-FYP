import '../entities/StudentFAQ.dart';
import '../repositories/StudentChatbotRepository.dart';

class GetStudentFAQsUseCase {
  final StudentChatbotRepository repository;
  GetStudentFAQsUseCase(this.repository);

  Future<List<StudentFAQ>> call() async {
    return await repository.getFAQs();
  }
}
