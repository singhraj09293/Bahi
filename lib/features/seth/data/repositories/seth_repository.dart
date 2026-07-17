
import 'package:challan_app/features/seth/data/model/seth_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SethRepository {
  final _fireStore = FirebaseFirestore.instance;
  final _collection = 'master';

  Future<void> addSeth(SethModel masterModel) async {
    await _fireStore
        .collection(_collection)
        .doc(masterModel.masterId)
        .set(masterModel.toMap());
  }

  Stream<List<SethModel>> getSeth() {
    return _fireStore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((docs) => SethModel.fromMap(docs.data()))
          .toList();
    });
  }

  Future<void> deleteSeth(String masterId) async {
    await _fireStore.collection(_collection).doc(masterId).delete();
  }
}
