import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';

abstract class StudentPanelRepository {
  Future<Either<Fail, Student>> getStudentPanelProfile();
}
