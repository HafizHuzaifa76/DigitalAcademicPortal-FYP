import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscussionForumScreen extends StatefulWidget {
  final dynamic course;

  const DiscussionForumScreen({
    super.key,
    required this.course,
  });

  @override
  State<DiscussionForumScreen> createState() => _DiscussionForumScreenState();
}

class _DiscussionForumScreenState extends State<DiscussionForumScreen> {
  final List<Map<String, String>> messages = [
    {'sender': 'Student A', 'message': 'Can we have an extra class?', 'isTeacher': 'false'},
    {'sender': 'Teacher', 'message': 'Yes, we can schedule one next week.', 'isTeacher': 'true'},
    {'sender': 'Student B', 'message': 'What topics will be covered?', 'isTeacher': 'false'},
    {'sender': 'Teacher', 'message': 'We will cover the remaining topics from the syllabus.', 'isTeacher': 'true'},
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Forum - ${widget.course.courseCode}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isTeacher'] == 'true' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: message['isTeacher'] == 'true' ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['sender']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: message['isTeacher'] == 'true' ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          message['message']!,
                          style: TextStyle(
                            color: message['isTeacher'] == 'true' ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        messages.add({
                          'sender': 'Teacher',
                          'message': _messageController.text,
                          'isTeacher': 'true',
                        });
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 