import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/StudentDiaryController.dart';

import '../../domain/entities/Note.dart';

class StudentDiaryPage extends StatelessWidget {
  final String deptName;
  final String studentRollNo;

  StudentDiaryPage({super.key, required this.deptName, required this.studentRollNo});

  final StudentDiaryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.initialize(deptName, studentRollNo);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Diary', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Get.theme.primaryColor),
            onPressed: () => _showSortOptions(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Get.theme.primaryColor),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: Icon(Icons.search, color: Get.theme.primaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Get.theme.primaryColor),
                    ),
                  ),
                  onChanged: (_) => controller.filterNotes(),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', true),
                      _buildFilterChip('Completed', false),
                      _buildFilterChip('Pending', false),
                      _buildFilterChip('High Priority', false),
                      _buildFilterChip('Medium Priority', false),
                      _buildFilterChip('Low Priority', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredNotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined, 
                        size: 64, 
                        color: Get.theme.primaryColor.withOpacity(0.5)
                      ),
                      const SizedBox(height: 16),
                      Text('No notes found.',
                          style: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.7),
                            fontSize: 16
                          )
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = controller.filteredNotes[index];
                  return _buildNoteCard(note);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
        onPressed: () async {
          final newNote = await Get.to(() => CreateNoteScreen());
          if (newNote != null) {
            controller.addNote(newNote);
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: controller.currentFilter.value == label,
        onSelected: (bool selected) {
          controller.setFilter(label);
        },
        backgroundColor: Colors.white,
        selectedColor: Get.theme.primaryColor.withOpacity(0.2),
        checkmarkColor: Get.theme.primaryColor,
        labelStyle: TextStyle(
          color: controller.currentFilter.value == label ? Get.theme.primaryColor : Colors.black54,
          fontWeight: controller.currentFilter.value == label ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Get.theme.primaryColor.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () async {
          final updatedNote = await Get.to(() => EditNoteScreen(note: note));
          if (updatedNote != null) {
            controller.updateNote(updatedNote);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildPriorityIndicator(note.priority ?? 'Medium'),
                  IconButton(
                    icon: Icon(
                      note.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: Get.theme.primaryColor,
                    ),
                    onPressed: () => controller.toggleCompletion(note),
                  ),
                ],
              ),
              if (note.category != null && note.category!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    note.category!,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                note.content,
                style: TextStyle(
                  color: Get.theme.primaryColor.withOpacity(0.8),
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.dateTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.theme.primaryColor.withOpacity(0.6),
                    ),
                  ),
                  Row(
                    children: [
                      if (note.dueDate != null)
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Get.theme.primaryColor.withOpacity(0.6),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Get.theme.primaryColor.withOpacity(0.7),
                        ),
                        onPressed: () => _showDeleteConfirmation(note),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showDeleteConfirmation(Note note) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Note',
            style: TextStyle(color: Get.theme.primaryColor)),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Get.theme.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteNote(note);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sort Notes',
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.access_time, color: Get.theme.primaryColor),
              title: const Text('Date Created'),
              trailing: controller.currentSort.value == 'Date Created'
                  ? Icon(
                      controller.sortAscending.value
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Get.theme.primaryColor,
                    )
                  : null,
              onTap: () {
                controller.setSort('Date Created',
                    ascending: controller.currentSort.value == 'Date Created'
                        ? !controller.sortAscending.value
                        : true);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.priority_high, color: Get.theme.primaryColor),
              title: const Text('Priority'),
              trailing: controller.currentSort.value == 'Priority'
                  ? Icon(
                      controller.sortAscending.value
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Get.theme.primaryColor,
                    )
                  : null,
              onTap: () {
                controller.setSort('Priority',
                    ascending: controller.currentSort.value == 'Priority'
                        ? !controller.sortAscending.value
                        : true);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.title, color: Get.theme.primaryColor),
              title: const Text('Title'),
              trailing: controller.currentSort.value == 'Title'
                  ? Icon(
                      controller.sortAscending.value
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Get.theme.primaryColor,
                    )
                  : null,
              onTap: () {
                controller.setSort('Title',
                    ascending: controller.currentSort.value == 'Title'
                        ? !controller.sortAscending.value
                        : true);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter Notes',
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.check_circle_outline,
                  color: Get.theme.primaryColor),
              title: const Text('Completed'),
              onTap: () {
                controller.setFilter('Completed');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.pending_actions,
                  color: Get.theme.primaryColor),
              title: const Text('Pending'),
              onTap: () {
                controller.setFilter('Pending');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Get.theme.primaryColor),
              title: const Text('By Category'),
              onTap: () {
                _showCategoryFilter(context);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter(BuildContext context) {
    final categories = [
      'Assignment',
      'Quiz',
      'Project',
      'Exam',
      'Personal',
      'Other'
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Category',
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...categories.map((category) => ListTile(
                  title: Text(category),
                  onTap: () {
                    controller.setFilter(category);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedPriority = 'Medium';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Note', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
              ),
            ),
            const SizedBox(height: 16),
            TextField(
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
              ),
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
                  initialDate: DateTime.now(),
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
                final now = DateTime.now();
                final formatted =
                    "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
                final note = Note(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  dateTime: formatted,
                  id: '',
                  priority: selectedPriority,
                  category: selectedCategory,
                  dueDate: dueDate?.toString(),
                );
                Navigator.pop(context, note);
              },
              icon: Icon(Icons.save),
              label: Text('Save Note'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;
  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
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
      dueDate = DateTime.parse(widget.note.dueDate!);
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
              Navigator.pop(context, null);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
              ),
            ),
            const SizedBox(height: 16),
            TextField(
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
              ),
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
    );
  }
}
