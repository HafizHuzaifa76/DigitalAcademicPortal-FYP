import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import '../datasources/StudentPanelRemoteDataSource.dart';
import '../../domain/repositories/StudentPanelRepository.dart';

class StudentPanelRepositoryImpl implements StudentPanelRepository {
  final StudentPanelRemoteDataSource remoteDataSource;

  StudentPanelRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, Student>> getStudentPanelProfile() async {
    try {
      final teacher = await remoteDataSource.getStudentPanelProfile();
      return Right(teacher);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
