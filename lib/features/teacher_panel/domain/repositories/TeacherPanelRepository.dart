import 'package:dartz/dartz.dart';
import '../../../../shared/domain/entities/Teacher.dart';

abstract class TeacherPanelRepository {
  Future<Either<Fail, Teacher>> getTeacherPanelProfile();
}