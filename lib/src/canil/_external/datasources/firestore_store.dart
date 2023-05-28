import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/canil/_infra/datasources/store.dart';
import 'package:coworkers/src/canil/domain/entities/store.dart';
import 'package:flutter/foundation.dart';

class FirestoreStoreImpl implements StoreDatasource {
  final FirebaseFirestore firestore;
  final String collectionPath = kDebugMode ? 'dev_stores' : 'stores';

  FirestoreStoreImpl(this.firestore);

  @override
  Future<String> add(Store store) async {
    final addMethod = await firestore.collection(collectionPath)
      .add(
        store.toJson()
          ..['createdAt'] = Timestamp.now()
          ..['updatedAt'] = Timestamp.now(),
      );
    return addMethod.id;
  }
}
