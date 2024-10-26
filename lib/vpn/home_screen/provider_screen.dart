import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetItemProvider with ChangeNotifier {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  GetItemProvider() {
    fetchItems();
  }

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('items').get();

      items = querySnapshot.docs.map((doc) {
        return {
          'text': doc['text'],
          'date': doc['date'],
          'images': List<String>.from(doc['images']),
        };
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching items: $e');
    }
  }
}
