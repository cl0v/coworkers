import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/main.dart';
import 'package:coworkers/src/store/_infra/datasources/store.dart';
import 'package:coworkers/src/store/domain/entities/store.dart';
import 'package:coworkers/src/store/feats/add/domain/entities/create_store_result.dart';
import 'package:flutter/foundation.dart';
import '../mappers/firestore_store.dart';

class FirestoreStoreImpl implements StoreDatasource {
  final FirebaseFirestore firestore;
  final String collectionPath = kDebugMode ? 'dev_stores' : 'stores';

  FirestoreStoreImpl(this.firestore);

  @override
  Future<CreateStoreResult> add(Store store) async {
    final Store? duplicate = await checkForDuplicate(store);
    if (duplicate != null) {
      return CreateStoreResult(
        value: store,
        status: StoreCreationStatus.duplicated,
      );
    }
    try {
      final addMethod = await firestore.collection(collectionPath).add(
            store.toJson()
              ..['createdAt'] = Timestamp.now()
              ..['updatedAt'] = Timestamp.now()
              ..['createdBy'] = globalCode,
          );

      return CreateStoreResult(
        value: addMethod.id,
        status: StoreCreationStatus.created,
      );
    } catch (e) {
      return CreateStoreResult(
        value: store,
        status: StoreCreationStatus.error,
        message: e.toString(),
      );
    }
  }

  // Checa se existe algum contato com o mesmo telefone ou instagram
  Future<Store?> checkForDuplicate(Store store) async {
    for (var phone in store.contact.phones) {
      final query = await firestore
          .collection(collectionPath)
          .where('contact.phones', arrayContains: phone)
          .get();
      if (query.docs.isNotEmpty) {
        return FirestoreStoreMapper.fromDoc(query.docs.first);
      }
    }
    final query = await firestore
        .collection(collectionPath)
        .where('contact.instagramDetails.value',
            isEqualTo: store.contact.instagramDetails?.value)
        .get();
    if (query.docs.isNotEmpty) {
      return FirestoreStoreMapper.fromDoc(query.docs.first);
    }
    return null;
  }
}
