import 'package:cloud_firestore/cloud_firestore.dart';

// ── Firestore Service ─────────────────────────────────────────────────────────
/// Thin wrapper around Firestore to handle all farm data CRUD.
/// Data is namespaced per user: `users/{uid}/collection/{docId}`
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  // ── Collection refs ───────────────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> _col(String uid, String col) =>
      _db.collection('users').doc(uid).collection(col);

  // ── Generic CRUD ──────────────────────────────────────────────────────────

  /// Write or overwrite a single document (merge = false)
  Future<void> set(String uid, String collection, String docId,
      Map<String, dynamic> data) async {
    await _col(uid, collection).doc(docId).set(data);
  }

  /// Delete a single document
  Future<void> delete(String uid, String collection, String docId) async {
    await _col(uid, collection).doc(docId).delete();
  }

  /// Fetch all documents in a collection
  Future<List<Map<String, dynamic>>> getAll(
      String uid, String collection) async {
    final snap = await _col(uid, collection).get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  /// Stream all documents (real-time)
  Stream<List<Map<String, dynamic>>> streamAll(
      String uid, String collection) {
    return _col(uid, collection).snapshots().map(
          (snap) => snap.docs
              .map((d) => {'id': d.id, ...d.data()})
              .toList(),
        );
  }

  // ── Batch write (for sync) ────────────────────────────────────────────────
  /// Write many documents at once (uses Firestore WriteBatch, max 500)
  Future<void> batchWrite(String uid, String collection,
      List<Map<String, dynamic>> items, String idField) async {
    final chunks = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < items.length; i += 400) {
      chunks.add(items.sublist(i, i + 400 > items.length ? items.length : i + 400));
    }
    for (final chunk in chunks) {
      final batch = _db.batch();
      for (final item in chunk) {
        final docId = item[idField] as String;
        batch.set(_col(uid, collection).doc(docId), item);
      }
      await batch.commit();
    }
  }

  // ── Collection names (constants) ─────────────────────────────────────────
  static const flocks = 'flocks';
  static const batches = 'batches';
  static const eggRecords = 'eggRecords';
  static const eggSales = 'eggSales';
  static const feedTypes = 'feedTypes';
  static const feedLogs = 'feedLogs';
  static const healthRecords = 'healthRecords';
  static const vaccinationSchedules = 'vaccinationSchedules';
  static const medicineStock = 'medicineStock';
  static const transactions = 'transactions';

  // ── User profile ───────────────────────────────────────────────────────────
  Future<void> saveUserProfile(
      String uid, Map<String, dynamic> profile) async {
    await _db
        .collection('users')
        .doc(uid)
        .set(profile, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
}
