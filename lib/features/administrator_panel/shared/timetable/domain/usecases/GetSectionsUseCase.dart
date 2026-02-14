import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/AllSectionsUseCase.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../../../sections/domain/entities/Section.dart';

class GetSectionsUseCase implements UseCase<List<Section>, SemesterParams>{
  final AllSectionsUseCase useCase;

  GetSectionsUseCase(this.useCase);

  @override
  Future<Either<Fail, List<Section>>> execute(SemesterParams params) async {
    return await useCase.execute(params);
  }
}