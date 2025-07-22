import '../entities/StudentFAQ.dart';
import '../repositories/StudentChatbotRepository.dart';

class GetStudentFAQsUseCase {
  final StudentChatbotRepository repository;
  GetStudentFAQsUseCase(this.repository);

  List<StudentFAQ> call() {
    return repository.getFAQs();
  }
}
