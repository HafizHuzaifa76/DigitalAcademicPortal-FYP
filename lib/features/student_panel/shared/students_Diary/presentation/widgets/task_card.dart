import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
//import '../widgets/task_modal.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function onEdit;
  final Function onDelete;
  final Function onMarkComplete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Complete/Incomplete Button
            IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () => onMarkComplete(),
            ),
            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(),
            ),
          ],
        ),
      ),
    );
  }
}
