import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class StudentChatbotRemoteDataSource {
  final String openAIApiKey;

  StudentChatbotRemoteDataSource({required this.openAIApiKey});

  Future<String> sendMessageToOpenAI(String message) async {
    print('message');
    print(message);

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': openAIApiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Navigate safely in the JSON structure
        final textResponse =
            data['candidates']?[0]['content']?['parts']?[0]['text'];
        if (textResponse != null) {
          return textResponse;
        } else {
          throw Exception("No text found in Gemini response");
        }
      } else {
        print('Failed to get response from Gemini: ${response.body}');
        throw Exception('Failed to get response from Gemini: ${response.body}');
      }
    } catch (e) {
      print('Failed to get response from Gemini in catch block: $e');
      throw Exception('Failed to get response from Gemini: $e');
    }
  }
}
