import '../../domain/entities/store.dart';
import '../../feats/add/domain/entities/create_store_result.dart';

abstract class StoreDatasource {
  Future<CreateStoreResult> add(Store store);
  Future<CreateStoreResult?> checkInstagramDuplication(String instagram);
  Future<CreateStoreResult?> checkPhonesDuplication(List<String> phones);


}