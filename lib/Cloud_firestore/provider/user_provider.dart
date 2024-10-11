import 'package:flutter/material.dart';
import '../Model/model.dart';
import '../Utils/firestore.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<User> _users = [];

  List<User> get users => _users;

  UserProvider() {
    loadUsers();
  }

  void loadUsers() {
    _firestoreService.getUsers().listen((userList) {
      _users = userList;
      notifyListeners();
    });
  }

  Future<void> addUser(User user) async {
    await _firestoreService.addUser(user);
  }

  Future<void> updateUser(User user) async {
    await _firestoreService.updateUser(user);
  }

  Future<void> deleteUser(String id) async {
    await _firestoreService.deleteUser(id);
  }
}
