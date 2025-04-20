import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Note {
  String title;
  String content;
  bool isCompleted;
  String dateTime;

  Note({required this.title, required this.content, this.isCompleted = false, required this.dateTime});

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'isCompleted': isCompleted,
    'dateTime': dateTime,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    isCompleted: json['isCompleted'],
    dateTime: json['dateTime'],
  );
}

class Stu_Diary extends StatefulWidget {
  @override
  _Stu_DiaryState createState() => _Stu_DiaryState();
}

class _Stu_DiaryState extends State<Stu_Diary> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
    searchController.addListener(_filterNotes);
  }

  void _filterNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) =>
      note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query)).toList();
    });
  }

  void loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesData = prefs.getString('notes');
    if (notesData != null) {
      List<dynamic> jsonData = jsonDecode(notesData);
      setState(() {
        notes = jsonData.map((e) => Note.fromJson(e)).toList();
        filteredNotes = List.from(notes);
      });
    }
  }

  void saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> data = notes.map((e) => e.toJson()).toList();
    prefs.setString('notes', jsonEncode(data));
  }

  void addNote(Note note) {
    setState(() {
      notes.insert(0, note);
      filteredNotes = List.from(notes);
    });
    saveNotes();
  }

  void updateNote(int index, Note updatedNote) {
    setState(() {
      int originalIndex = notes.indexOf(filteredNotes[index]);
      notes[originalIndex] = updatedNote;
      filteredNotes[index] = updatedNote;
    });
    saveNotes();
  }

  void deleteNote(int index) async {
    Note noteToRemove = filteredNotes[index];
    setState(() {
      notes.remove(noteToRemove);
      filteredNotes.removeAt(index);
    });
    saveNotes();
  }

  void toggleCompletion(int index) {
    setState(() {
      int originalIndex = notes.indexOf(filteredNotes[index]);
      notes[originalIndex].isCompleted = !notes[originalIndex].isCompleted;
      filteredNotes[index] = notes[originalIndex];
    });
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C2D23),
        title: Text('Student Diary', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Color(0xFF263D2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
              child: Text(
                'No notes found.',
                style: TextStyle(color: Colors.white70),
              ),
            )
                : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return GestureDetector(
                  onTap: () async {
                    final updatedNote = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(note: note),
                      ),
                    );
                    if (updatedNote != null) {
                      updateNote(index, updatedNote);
                    }
                  },
                  child: Card(
                    color: Color(0xFF263D2A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                    decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  note.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: Colors.greenAccent,
                                ),
                                onPressed: () => toggleCompletion(index),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            note.dateTime,
                            style: TextStyle(fontSize: 12, color: Colors.white38),
                          ),
                          SizedBox(height: 8),
                          Text(
                            note.content,
                            style: TextStyle(color: Colors.white70),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => deleteNote(index),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4C9A2A),
        child: Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );
          if (newNote != null) {
            addNote(newNote);
          }
        },
      ),
      backgroundColor: Color(0xFF121A13),
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
                final formatted = "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
                final note = Note(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  dateTime: formatted,
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
                final formatted = "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
                final updatedNote = Note(
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
