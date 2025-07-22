import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class StudentChatbotRemoteDataSource {
  final String openAIApiKey;

  StudentChatbotRemoteDataSource({required this.openAIApiKey});

  Future<String> sendMessageToOpenAI(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 150,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Failed to get response from OpenAI: ${response.body}');
    }
  }
}
