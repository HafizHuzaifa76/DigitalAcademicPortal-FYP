import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/Note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String selectedPriority;
  String? selectedCategory;
  DateTime? dueDate;

  final List<String> categories = [
    'Assignment',
    'Quiz',
    'Project',
    'Exam',
    'Personal',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
    selectedPriority = widget.note.priority ?? 'Medium';
    selectedCategory = widget.note.category;
    if (widget.note.dueDate != null) {
      dueDate = DateTime.tryParse(widget.note.dueDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Note', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, null); // Return null to delete
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Wrap with Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                style: TextStyle(color: Get.theme.primaryColor),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder( 
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                style: TextStyle(color: Get.theme.primaryColor),
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Note',
                  labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder( 
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Note content cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor),
                  ),
                ),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Get.theme.primaryColor),
                  ),
                ),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Get.theme.primaryColor),
                title: Text(
                  dueDate == null
                      ? 'Set Due Date'
                      : 'Due: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
                trailing: dueDate != null
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Get.theme.primaryColor),
                        onPressed: () {
                          setState(() {
                            dueDate = null;
                          });
                        },
                      )
                    : null,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      dueDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final now = DateTime.now();
                    final formatted =
                        "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
                    final updatedNote = Note(
                      id: widget.note.id,
                      title: titleController.text.trim(),
                      content: contentController.text.trim(),
                      dateTime: formatted,
                      isCompleted: widget.note.isCompleted,
                      priority: selectedPriority,
                      category: selectedCategory,
                      dueDate: dueDate?.toString(),
                    );
                    Navigator.pop(context, updatedNote);
                  }
                },
                icon: Icon(Icons.save),
                label: Text('Update Note'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
