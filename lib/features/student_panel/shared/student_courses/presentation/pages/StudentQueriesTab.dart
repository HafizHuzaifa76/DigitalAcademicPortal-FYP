import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/StudentCourse.dart';

class StudentQueriesTab extends StatelessWidget {
  final StudentCourse course;
  const StudentQueriesTab({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Pending Queries'),
        _buildQueryCard(
          'Pending Queries',
          'View and manage your pending queries',
          '2 Pending',
          Icons.help_outline,
          Colors.orange,
          () => Get.to(() => PendingQueriesScreen()),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Responded Queries'),
        _buildQueryCard(
          'Responded Queries',
          'View queries that have been answered',
          '2 Responded',
          Icons.check_circle_outline,
          Colors.green,
          () => Get.to(() => RespondedQueriesScreen()),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.primaryColor.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQueryCard(String title, String subtitle, String status,
      IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// Pending Queries Screen
class PendingQueriesScreen extends StatefulWidget {
  @override
  State<PendingQueriesScreen> createState() => _PendingQueriesScreenState();
}

class _PendingQueriesScreenState extends State<PendingQueriesScreen> {
  List<Map<String, dynamic>> pendingQueries = [
    {
      'question': 'What is the deadline for Assignment 1?',
      'description': 'I want to know the last date to submit Assignment 1.'
    },
    {
      'question': 'Will there be a quiz next week?',
      'description': 'Is there any quiz scheduled for next week?'
    },
  ];

  void _askQuery() async {
    final result = await Get.to(() => AskQueryScreen());
    if (result != null && result is Map<String, String>) {
      setState(() {
        pendingQueries.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Queries')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.add_comment, size: 23),
                label: const Text('Ask a New Query'),
                onPressed: _askQuery,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: pendingQueries.length,
                itemBuilder: (context, index) {
                  final query = pendingQueries[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.orange),
                      title: Text(query['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(query['description']),
                      trailing: const Text('Pending', style: TextStyle(color: Colors.orange)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Responded Queries Screen
class RespondedQueriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> respondedQueries = [
    {
      'question': 'Is attendance mandatory?',
      'description': 'Do I need to attend every class?',
      'answer': 'Yes, attendance is mandatory for all classes.'
    },
    {
      'question': 'Can we use calculators in the exam?',
      'description': 'Are calculators allowed in the final exam?',
      'answer': 'Yes, you can use non-programmable calculators.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responded Queries')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: respondedQueries.length,
          itemBuilder: (context, index) {
            final query = respondedQueries[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(query['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(query['description']),
                    const SizedBox(height: 8),
                    Text('Answer: ${query['answer']}', style: const TextStyle(color: Colors.green)),
                  ],
                ),
                trailing: const Text('Responded', style: TextStyle(color: Colors.green)),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Ask Query Screen
class AskQueryScreen extends StatefulWidget {
  @override
  State<AskQueryScreen> createState() => _AskQueryScreenState();
}

class _AskQueryScreenState extends State<AskQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  String question = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Query')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your question' : null,
                onSaved: (value) => question = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Get.back(result: {
                      'question': question,
                      'description': description,
                    });
                  }
                },
                child: const Text('Post Query', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 