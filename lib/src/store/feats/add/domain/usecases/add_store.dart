import '../../../../_infra/repositories/store.dart';
import '../../../../domain/entities/store.dart';
import '../entities/create_store_result.dart';

abstract class AddStoreUseCase {
  Future<CreateStoreResult> call(Store store);
}

class AddStoreUseCaseImpl implements AddStoreUseCase {
  AddStoreUseCaseImpl({required this.repository});

  final StoreRepository repository;

  @override
  Future<CreateStoreResult> call(Store store) async {
    return await repository.add(store);
  }
}