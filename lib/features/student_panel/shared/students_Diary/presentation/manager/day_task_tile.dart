import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../../domain/entities/task.dart';
import '../widgets/task_model.dart';

class DayTaskTile extends StatefulWidget {
  final DateTime date;

  const DayTaskTile({super.key, required this.date});

  @override
  _DayTaskTileState createState() => _DayTaskTileState();
}

class _DayTaskTileState extends State<DayTaskTile> {
  List<Task> tasks = []; // This will hold the tasks for the specific day

  // A function to fetch tasks for a specific date
  void fetchTasks() {
    // Fetch the tasks from a database or service and filter by date
    // For now, let's use mock data
    setState(() {
      tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: 'Description of Task 1',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description of Task 2',
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTasks(); // Fetch tasks when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${widget.date.day}/${widget.date.month}/${widget.date.year}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        // Display tasks for the specific date
        ...tasks.map((task) => TaskCard(
          task: task,
          onEdit: () {
            // Navigate to Task Modal for editing
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => TaskModal(task: task),
            );
          },
          onDelete: () {
            setState(() {
              tasks.remove(task); // Delete the task
            });
          },
          onMarkComplete: () {
            setState(() {
              task.isCompleted = !task.isCompleted; // Toggle completion status
            });
          },
        ))
            .toList(),
        const Divider(),
        // Add Task Button
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              // Show modal to add a new task
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const TaskModal(task: null),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
