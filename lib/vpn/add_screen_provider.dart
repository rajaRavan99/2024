import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddItemProvider with ChangeNotifier {
  GoogleMapController? mapController;
  static const LatLng initialPosition = LatLng(21.2234027, 72.8091743);
  final TextEditingController textController = TextEditingController();
  DateTime? selectedDate;
  List<XFile>? imageFiles = [];
  final ImagePicker picker = ImagePicker();
  bool isLoading = false; // Add isLoading state

  // Pick multiple images
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      imageFiles = pickedFiles;
      notifyListeners();
    }
  }

  // Upload images to Firebase Storage and return URLs
  Future<List<String>> _uploadImagesAndGetURLs() async {
    List<String> imageUrls = [];
    if (imageFiles != null) {
      for (var imageFile in imageFiles!) {
        String fileName = imageFile.name;
        File file = File(imageFile.path);

        try {
          TaskSnapshot snapshot = await FirebaseStorage.instance
              .ref('uploads/$fileName')
              .putFile(file);

          // Get the download URL and add it to the list
          String downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        } catch (e) {
          print('Error uploading $fileName: $e');
        }
      }
    }
    return imageUrls;
  }

  // Save data to Firestore
  Future<void> saveData() async {
    if (textController.text.isEmpty || selectedDate == null || imageFiles == null) {
      print('No data to save');
      return;
    }

    // Set loading to true
    isLoading = true;
    notifyListeners();

    // Upload images and get their URLs
    List<String> imageUrls = await _uploadImagesAndGetURLs();

    // Save text, date, and image URLs to Firestore
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    await items.add({
      'text': textController.text,
      'date': selectedDate?.toIso8601String(),
      'images': imageUrls,
    });

    // Set loading to false after saving
    isLoading = false;
    notifyListeners();

    // Clear the form after saving
    clearForm();
  }

  // Clear the form: reset text, date, and images
  void clearForm() {
    textController.clear();
    selectedDate = null;
    imageFiles = [];
    notifyListeners();
  }

  // Select Date
  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
