import 'package:dartz/dartz.dart';
import 'package:mosdetector/features/mosqiuto/data/models/mosquito_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/mosquito_repository.dart';

class GetMosquito implements UseCase<List<MosquitoModel>, NoParams> {
  final MosqiutoRepository repository;

  GetMosquito(this.repository);

  @override
  Future<Either<Failure, List<MosquitoModel>>> call(NoParams params) async {
    return await repository.getRecentDetections();
  }
}

class Params {
  final int id;
  Params({required this.id});
}
