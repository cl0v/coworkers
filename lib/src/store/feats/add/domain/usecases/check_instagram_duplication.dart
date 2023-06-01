import '../../../../_infra/repositories/store.dart';

abstract class CheckInstagramDuplicationUseCase{
  Future<String?> call(String instagram);
}

class CheckInstagramDuplicationUseCaseImpl implements CheckInstagramDuplicationUseCase{
  final StoreRepository repository;

  CheckInstagramDuplicationUseCaseImpl(this.repository);


  @override
  Future<String?> call(String instagram) async {
    final result = await repository.checkInstagramDuplication(instagram);
    return result?.message;
  }
}