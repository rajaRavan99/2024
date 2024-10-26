import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new user
  Future<void> addUser(User user) async {
    await _db.collection('users').add(user.toMap());
  }

  // Update a user
  Future<void> updateUser(User user) async {
    await _db.collection('users').doc(user.id).update(user.toMap());
  }

  // Delete a user
  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }

  // Get users stream
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
