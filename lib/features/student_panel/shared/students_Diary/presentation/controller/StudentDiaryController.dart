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

  // Filter and sort state
  RxString currentFilter = 'All'.obs;
  RxString currentSort = 'Date Created'.obs;
  RxBool sortAscending = true.obs;
  RxBool isLoading = false.obs;

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
    var filtered = notes.where((note) =>
        note.title.toLowerCase().contains(query) ||
        note.content.toLowerCase().contains(query));

    // Apply category filter
    if (currentFilter.value != 'All') {
      if (currentFilter.value == 'Completed') {
        filtered = filtered.where((note) => note.isCompleted);
      } else if (currentFilter.value == 'Pending') {
        filtered = filtered.where((note) => !note.isCompleted);
      } else if (currentFilter.value.contains('Priority')) {
        final priority = currentFilter.value.split(' ')[0].toLowerCase();
        filtered =
            filtered.where((note) => note.priority?.toLowerCase() == priority);
      }
    }

    // Apply sorting
    final sorted = filtered.toList();
    switch (currentSort.value) {
      case 'Date Created':
        sorted.sort((a, b) => sortAscending.value
            ? a.dateTime.compareTo(b.dateTime)
            : b.dateTime.compareTo(a.dateTime));
        break;
      case 'Priority':
        sorted.sort((a, b) {
          final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          final aPriority =
              priorityOrder[a.priority?.toLowerCase() ?? 'medium'] ?? 1;
          final bPriority =
              priorityOrder[b.priority?.toLowerCase() ?? 'medium'] ?? 1;
          return sortAscending.value
              ? aPriority.compareTo(bPriority)
              : bPriority.compareTo(aPriority);
        });
        break;
      case 'Title':
        sorted.sort((a, b) => sortAscending.value
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
    }

    filteredNotes.value = sorted;
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
    filterNotes();
  }

  void setSort(String sort, {bool ascending = true}) {
    currentSort.value = sort;
    sortAscending.value = ascending;
    filterNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    try {
      final result = await allNotesUseCase.execute(
          NoteParams(deptName: deptName, studentRollNo: rollNo, note: null));
      result.fold(
        (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
        (data) {
          notes.value = data;
          filterNotes();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(Note note) async {
    final result = await addNoteUseCase.execute(
        NoteParams(deptName: deptName, studentRollNo: rollNo, note: note));
    result.fold(
      (failure) => Utils().showErrorSnackBar('Error', failure.toString()),
      (newNote) {
        Utils().showSuccessSnackBar('Success', 'Note added successfully');
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
        Utils().showSuccessSnackBar('Success', 'Note updated successfully');
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
        Utils().showSuccessSnackBar('Success', 'Note deleted successfully');
        loadNotes();
      },
    );
  }

  void toggleCompletion(Note note) {
    final updatedNote = note.copyWith(isCompleted: !note.isCompleted);
    updateNote(updatedNote);
  }
}
