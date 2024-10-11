import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model.dart';

class ItemProvider with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('items');
  List<Item> items = [];

  ItemProvider() {
    fetchItems();
  }

  void fetchItems() async {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      items = data?.entries
          .map((entry) => Item.fromJson(Map<String, dynamic>.from(entry.value), entry.key))
          .toList() ??
          [];
      notifyListeners();
    });
  }

  Future<void> addItem(String name) async {
    final newItem = Item(id: '', name: name);
    final newRef = _dbRef.push();
    await newRef.set(newItem.toJson());
  }

  Future<void> updateItem(Item item) async {
    await _dbRef.child(item.id).update(item.toJson());
  }

  Future<void> deleteItem(String id) async {
    await _dbRef.child(id).remove();
  }
}
