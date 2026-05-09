import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom_toast.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Generic Create
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      final now = DateTime.now().toIso8601String();
      final finalData = {
        ...data,
        'createdAt': data['createdAt'] ?? now,
        'updatedAt': now,
      };
      await _db.collection(collection).add(finalData);
    } catch (e) {
      CustomToast.showError('Error', 'Failed to add document: $e');
    }
  }

  // Generic Create with Specific ID
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      final now = DateTime.now().toIso8601String();
      final finalData = {
        ...data,
        'createdAt': data['createdAt'] ?? now,
        'updatedAt': now,
      };
      await _db.collection(collection).doc(docId).set(finalData, SetOptions(merge: true));
    } catch (e) {
      CustomToast.showError('Error', 'Failed to set document: $e');
    }
  }

  // Generic Read (Stream)
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String collection) {
    return _db.collection(collection).snapshots();
  }

  // Generic Read (One-time)
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collection, String docId) async {
    return await _db.collection(collection).doc(docId).get();
  }

  // Generic Update
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      final now = DateTime.now().toIso8601String();
      final finalData = {
        ...data,
        'updatedAt': now,
      };
      await _db.collection(collection).doc(docId).update(finalData);
    } catch (e) {
      CustomToast.showError('Error', 'Failed to update document: $e');
    }
  }

  // Generic Delete
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _db.collection(collection).doc(docId).delete();
    } catch (e) {
      CustomToast.showError('Error', 'Failed to delete document: $e');
    }
  }
}
