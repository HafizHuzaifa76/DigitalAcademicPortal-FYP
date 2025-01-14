
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class AddStudentListUseCase implements UseCase<void, List<Student>>{
  final StudentRepository repository;

  AddStudentListUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(List<Student> studentsList) async {

    List<Student> morningStudentsList = studentsList.where((student) => student.studentShift.toLowerCase() == 'morning').toList();
    List<Student> eveningStudentsList = studentsList.where((student) => student.studentShift.toLowerCase() == 'evening').toList();

    return await repository.addStudentList(morningStudentsList, eveningStudentsList);
  }
}
