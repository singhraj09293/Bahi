import 'package:challan_app/features/workers/data/model/other_staff_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'other_staff';

  Future<void> addStaff(OtherStaffModel Staff) async {
    final docRef = _firestore.collection(_collection).doc();
    await docRef.set(Staff.toMap()..['id'] = docRef.id);
  }

  Stream<List<OtherStaffModel>> getStaff() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => OtherStaffModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> updateStaff(OtherStaffModel staff) async {
    return _firestore
        .collection(_collection)
        .doc(staff.id)
        .update(staff.toMap());
  }

  Future<void> deleteStaff(String staffId) async {
    return _firestore.collection(_collection).doc(staffId).delete();
  }
}
