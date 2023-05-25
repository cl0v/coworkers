import '../../domain/entities/store.dart';

abstract class StoreDatasource {
  Future<String> add(Store store);
}