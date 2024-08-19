import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Fail, Type>> execute(Params params);
}