import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/Note.dart';
import '../../domain/usecases/AddNoteUseCase.dart';
import '../../domain/usecases/AllNotesUseCase.dart';
import '../../domain/usecases/DeleteNoteUseCase.dart';
import '../../domain/usecases/EditNoteUseCase.dart';

class StudentDiaryController extends GetxController {
  final AddNoteUseCase addNoteUseCase;
  final EditNoteUseCase editNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final AllNotesUseCase allNotesUseCase;

  StudentDiaryController({
    required this.addNoteUseCase,
    required this.editNoteUseCase,
    required this.deleteNoteUseCase,
    required this.allNotesUseCase,
  });

  RxList<Note> notes = <Note>[].obs;
  RxList<Note> filteredNotes = <Note>[].obs;
  TextEditingController searchController = TextEditingController();

  String deptName = '';
  String rollNo = '';

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(filterNotes);
  }

  void initialize(String dept, String roll) {
    deptName = dept;
    rollNo = roll;
    loadNotes();
  }

  void filterNotes() {
    final query = searchController.text.toLowerCase();
    filteredNotes.value = notes
        .where((note) =>
            note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query))
        .toList();
  }

  Future<void> loadNotes() async {
    final result = await allNotesUseCase.execute(
        NoteParams(deptName: deptName, studentRollNo: rollNo, note: null));
    result.fold(
      (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
      (data) {
        notes.value = data;
        filteredNotes.value = List.from(data);
      },
    );
  }

  Future<void> addNote(Note note) async {
    final result = await addNoteUseCase.execute(
        NoteParams(deptName: deptName, studentRollNo: rollNo, note: note));
    result.fold(
      (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
      (newNote) {
        Utils().showErrorSnackBar('Success', 'Note added successfully');
        loadNotes();
      },
    );
  }

  Future<void> updateNote(Note note) async {
    final result = await editNoteUseCase.execute(
        NoteParams(deptName: deptName, studentRollNo: rollNo, note: note));
    result.fold(
      (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
      (updatedNote) {
        Utils().showErrorSnackBar('Success', 'Note updated successfully');
        loadNotes();
      },
    );
  }

  Future<void> deleteNote(Note note) async {
    final result = await deleteNoteUseCase.execute(
        NoteParams(deptName: deptName, studentRollNo: rollNo, note: note));
    result.fold(
      (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
      (_) {
        Utils().showErrorSnackBar('Success', 'Note deleted successfully');
        loadNotes();
      },
    );
  }

  void toggleCompletion(Note note) {
    final updatedNote = note.copyWith(isCompleted: !note.isCompleted);
    updateNote(updatedNote);
  }
}
