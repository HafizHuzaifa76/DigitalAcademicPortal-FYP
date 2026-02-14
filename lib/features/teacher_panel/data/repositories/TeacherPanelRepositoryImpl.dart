import 'package:dartz/dartz.dart';
import '../../../../shared/domain/entities/Teacher.dart';
import '../datasources/TeacherPanelRemoteDataSource.dart';
import '../../domain/repositories/TeacherPanelRepository.dart';

class TeacherPanelRepositoryImpl implements TeacherPanelRepository {
  final TeacherPanelRemoteDataSource remoteDataSource;

  TeacherPanelRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, Teacher>> getTeacherPanelProfile() async {
    try {
      final teacher = await remoteDataSource.getTeacherPanelProfile();
      return Right(teacher);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}