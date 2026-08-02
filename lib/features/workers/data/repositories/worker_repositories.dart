import 'package:challan_app/features/workers/data/model/worker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkerRepositories {
  final _fireStore = FirebaseFirestore.instance;
  final _collection = 'worker';

  Future<void> addWorker(WorkerModel workerModel) async {
    await _fireStore
        .collection(_collection)
        .doc(workerModel.workerId)
        .set(workerModel.toMap());
  }

  Stream<List<WorkerModel>> getWorker() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _fireStore
        .collection(_collection)
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((docs) => WorkerModel.fromMap(docs.data()))
          .toList();
    });
  }

  Future<void> deleteWorker(String workerId) async {
    await _fireStore.collection(_collection).doc(workerId).delete();
  }
}