import '../../domain/entities/store.dart';
import '../../feats/add/domain/entities/create_store_result.dart';
import '../datasources/store.dart';

abstract class StoreRepository {
  Future<CreateStoreResult> add(Store store);
}

class StoreRepositoryImpl implements StoreRepository {

  final StoreDatasource storeDatasource;

  StoreRepositoryImpl(this.storeDatasource);

  @override
  Future<CreateStoreResult> add(Store store) async {
    return storeDatasource.add(store);
  }
}