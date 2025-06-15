import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingQueriesScreen extends StatefulWidget {
  final dynamic course;

  const PendingQueriesScreen({
    super.key,
    required this.course,
  });

  @override
  State<PendingQueriesScreen> createState() => _PendingQueriesScreenState();
}

class _PendingQueriesScreenState extends State<PendingQueriesScreen> {
  final List<Map<String, String>> queries = [
    {'query': 'How can I access the lecture slides for the last session?', 'answer': ''},
    {'query': 'Could you clarify the requirements for the upcoming assignment?', 'answer': ''},
    {'query': 'Is there any additional reading material for the next topic?', 'answer': ''},
    {'query': 'Can you explain the concept of [specific topic] in more detail?', 'answer': ''},
    {'query': 'What are the key points to focus on for the next quiz?', 'answer': ''},
  ];

  final List<TextEditingController> controllers = List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Queries - ${widget.course.courseCode}'),
      ),
      body: ListView.builder(
        itemCount: queries.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Query ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    queries[index]['query']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controllers[index],
                    decoration: const InputDecoration(
                      hintText: 'Type your answer here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        queries[index]['answer'] = controllers[index].text;
                      });
                      Get.snackbar('Answered', 'Query answered successfully');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit Answer', style: TextStyle(fontSize: 16)),
                  ),
                  if (queries[index]['answer']!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Your Answer:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(queries[index]['answer']!),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 