import '../../../../_infra/repositories/store.dart';
import '../../../../domain/entities/store.dart';

abstract class AddStoreUseCase {
  Future<String> call(Store store);
}

class AddStoreUseCaseImpl implements AddStoreUseCase {
  AddStoreUseCaseImpl({required this.repository});

  final StoreRepository repository;

  @override
  Future<String> call(Store store) async {
    return await repository.add(store);
  }
}