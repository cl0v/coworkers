import '../../domain/entities/store.dart';
import '../../feats/add/domain/entities/create_store_result.dart';
import '../datasources/store.dart';

abstract class StoreRepository {
  Future<CreateStoreResult> add(Store store);
  Future<CreateStoreResult?> checkInstagramDuplication(String instagram);
  Future<CreateStoreResult?> checkPhonesDuplication(List<String> phones);
}

class StoreRepositoryImpl implements StoreRepository {
  final StoreDatasource storeDatasource;

  StoreRepositoryImpl(this.storeDatasource);

  @override
  Future<CreateStoreResult> add(Store store) async {
    return storeDatasource.add(store);
  }
  
  @override
  Future<CreateStoreResult?> checkInstagramDuplication(String instagram) {
    return storeDatasource.checkInstagramDuplication(instagram);
  }
  
  @override
  Future<CreateStoreResult?> checkPhonesDuplication(List<String> phones) {
    return storeDatasource.checkPhonesDuplication(phones);
  }
}
