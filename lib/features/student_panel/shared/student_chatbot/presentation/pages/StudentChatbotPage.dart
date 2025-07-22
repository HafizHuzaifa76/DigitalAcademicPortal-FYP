import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/StudentChatbotController.dart';

class StudentChatbotPage extends StatelessWidget {
  StudentChatbotPage({Key? key}) : super(key: key);

  final StudentChatbotController controller = Get.find();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student FAQ Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return Align(
                      alignment: message.isFromUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.isFromUser
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(message.text),
                      ),
                    );
                  },
                )),
          ),
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink()),
          Obx(() => Wrap(
                spacing: 8,
                children: controller.faqs
                    .map((faq) => ActionChip(
                          label: Text(faq.question),
                          onPressed: () {
                            textController.text = faq.question;
                          },
                        ))
                    .toList(),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      controller.sendMessage(text);
      textController.clear();
    }
  }
}
