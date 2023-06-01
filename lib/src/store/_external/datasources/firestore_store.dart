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
    final CreateStoreResult? duplicate = await _checkForDuplicate(store);
    if (duplicate != null) {
      return duplicate;
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
  Future<CreateStoreResult?> _checkForDuplicate(Store store) async {
    return await checkPhonesDuplication(store.contact.phones) ??
        await checkInstagramDuplication(
            store.contact.instagramDetails?.value ?? "");
  }

  @override
  Future<CreateStoreResult?> checkInstagramDuplication(String instagram) async {
    if (instagram.isEmpty) return null;
    final query = await firestore
        .collection(collectionPath)
        .where('contact.instagramDetails.value', isEqualTo: instagram)
        .get();
    if (query.docs.isNotEmpty) {
      return CreateStoreResult(
        value: FirestoreStoreMapper.fromDoc(query.docs.first),
        status: StoreCreationStatus.duplicated,
        message: "Instagram já cadastrado",
      );
    }
    return null;
  }

  @override
  Future<CreateStoreResult?> checkPhonesDuplication(List<String> phones) async {
    for (var phone in phones) {
      if (phone.length < "3398525199".length) return null;
      if (phone.isEmpty) continue;
      final query = await firestore
          .collection(collectionPath)
          .where('contact.phones', arrayContains: phone)
          .get();
      if (query.docs.isNotEmpty) {
        return CreateStoreResult(
          value: FirestoreStoreMapper.fromDoc(query.docs.first),
          status: StoreCreationStatus.duplicated,
          message: "Telefone já cadastrado",
        );
      }
    }
    return null;
  }
}
