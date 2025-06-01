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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2D23),
        title:
            const Text('Student Diary', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF263D2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => controller.filterNotes(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredNotes.isEmpty) {
                return const Center(
                  child: Text('No notes found.',
                      style: TextStyle(color: Colors.white70)),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = controller.filteredNotes[index];
                  return GestureDetector(
                    onTap: () async {
                      final updatedNote =
                          await Get.to(() => EditNoteScreen(note: note));
                      if (updatedNote != null) {
                        controller.updateNote(updatedNote);
                      }
                    },
                    child: Card(
                      color: const Color(0xFF263D2A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: note.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    note.isCompleted
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: Colors.greenAccent,
                                  ),
                                  onPressed: () =>
                                      controller.toggleCompletion(note),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.dateTime,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white38),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => controller.deleteNote(note),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C9A2A),
        child: const Icon(Icons.add),
        onPressed: () async {
          final newNote = await Get.to(() => CreateNoteScreen());
          if (newNote != null) {
            controller.addNote(newNote);
          }
        },
      ),
      backgroundColor: const Color(0xFF121A13),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C2D23),
        title: Text('New Note', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xFF121A13),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: contentController,
              style: TextStyle(color: Colors.white),
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Note',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
            ),
            Spacer(),
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
                );
                Navigator.pop(context, note);
              },
              icon: Icon(Icons.save),
              label: Text('Save Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4C9A2A),
                foregroundColor: Colors.white,
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C2D23),
        title: Text('Edit Note', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, null);
            },
          )
        ],
      ),
      backgroundColor: Color(0xFF121A13),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: contentController,
              style: TextStyle(color: Colors.white),
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Note',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            Spacer(),
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
                );
                Navigator.pop(context, updatedNote);
              },
              icon: Icon(Icons.save),
              label: Text('Update Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4C9A2A),
                foregroundColor: Colors.white,
                minimumSize: Size.fromHeight(48),
              ),
            )
          ],
        ),
      ),
    );
  }
}
