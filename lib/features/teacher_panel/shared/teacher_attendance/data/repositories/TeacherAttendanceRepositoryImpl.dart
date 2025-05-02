import 'package:dartz/dartz.dart';
import '../../domain/repositories/TeacherAttendanceRepository.dart';
import '../datasources/TeacherAttendanceRemoteDataSource.dart';
import '../../domain/entities/TeacherAttendance.dart';

class TeacherAttendanceRepositoryImpl implements TeacherAttendanceRepository {
  final TeacherAttendanceRemoteDataSource remoteDataSource;

  TeacherAttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<TeacherAttendance>>> getTeacherAttendance() async {
    // Implementation will go here
    throw UnimplementedError();
  }
}