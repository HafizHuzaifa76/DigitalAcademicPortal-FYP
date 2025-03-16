
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:flutter/cupertino.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class AddStudentListUseCase implements UseCase<void, StudentListParams>{
  final StudentRepository repository;

  AddStudentListUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(StudentListParams params) async {

    List<Student> morningStudentsList = params.studentList.where((student) => student.studentShift.toLowerCase() == 'morning').toList();
    List<Student> eveningStudentsList = params.studentList.where((student) => student.studentShift.toLowerCase() == 'evening').toList();
    debugPrint('morningStudentsList: ${morningStudentsList.length}');
    debugPrint('eveningStudentsList: ${eveningStudentsList.length}');

    return await repository.addStudentList(morningStudentsList, eveningStudentsList, params.isNewStudent);
  }
}
