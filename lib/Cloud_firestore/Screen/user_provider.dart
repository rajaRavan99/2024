import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UploadFormProvider extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  DateTime? _selectedDate;
  Position? _selectedLocation;
  File? _selectedImage;

  DateTime? get selectedDate => _selectedDate;
  Position? get selectedLocation => _selectedLocation;
  File? get selectedImage => _selectedImage;

  // Update date
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Request Location Permission and get location
  Future<void> setLocation() async {
    if (await _requestPermission(Permission.location)) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _selectedLocation = position;
      notifyListeners();
    } else {
      // Handle permission denied
    }
  }

  // Request Camera or Gallery Permissions and pick image
  Future<void> pickImage(ImageSource source) async {
    Permission permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    if (await _requestPermission(permission)) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } else {
      // Handle permission denied
    }
  }

  // Function to request permission
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  // Clear all form data
  void clearForm() {
    textController.clear();
    _selectedDate = null;
    _selectedLocation = null;
    _selectedImage = null;
    notifyListeners();
  }

  void handlePermissionDenied(BuildContext context, Permission permission) async {
    if (await permission.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission is permanently denied, please enable it in the settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied. Please grant permission.')),
      );
    }
  }

}
