import 'package:challan_app/features/challan/data/models/challan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallanRepository {
  final _fireStore = FirebaseFirestore.instance;
  final _collection = 'challan';

  Future<void> addChallan(ChallanModel challan) async {
    await _fireStore.collection(_collection).add(challan.toMap());
  }

  Stream<List<ChallanModel>> getChallan() {
    return _fireStore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChallanModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> updateChallan(ChallanModel challan) async {
    return _fireStore
        .collection(_collection)
        .doc(challan.challanNo)
        .update(challan.toMap());
  }

  Future<void> deleteChallan(String challanNo) async {
    return _fireStore.collection(_collection).doc(challanNo).delete();
  }
}
