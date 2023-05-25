import '../../domain/entities/store.dart';
import '../datasources/store.dart';

abstract class StoreRepository {
  Future<String> add(Store store);
}

class StoreRepositoryImpl implements StoreRepository {

  final StoreDatasource storeDatasource;

  StoreRepositoryImpl(this.storeDatasource);

  @override
  Future<String> add(Store store) async {
    return storeDatasource.add(store);
  }
}