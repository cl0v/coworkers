import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/store/domain/entities/store.dart';

class FirestoreStoreMapper{
  static Store fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    var json = doc.data() ?? {};
    return Store.fromJson(
     json..['id'] = doc.id
    );
  }
}