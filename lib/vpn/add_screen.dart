import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'add_screen_provider.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  LatLng? currentPosition;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Check location permission when the screen initializes
  }

  // Function to check location permission
  Future<void> _checkLocationPermission() async {
    // Check if location permission is granted
    PermissionStatus permission = await Permission.locationWhenInUse.status;

    if (permission == PermissionStatus.granted) {
      // Permission granted, get the current location
      _getCurrentLocation();
    } else if (permission == PermissionStatus.denied) {
      // If permission is denied, request the permission
      PermissionStatus requestStatus =
          await Permission.locationWhenInUse.request();

      if (requestStatus == PermissionStatus.granted) {
        // Permission granted after request, get the current location
        _getCurrentLocation();
      } else {
        // Permission denied permanently, you can show a dialog or a message to the user
        _showLocationDeniedDialog();
      }
    } else if (permission == PermissionStatus.permanentlyDenied) {
      // If permission is permanently denied, take the user to app settings
      await openAppSettings();
    }
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // Show a dialog when location permission is denied
  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location permission to show your current location on the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text Input Field
              TextFormField(
                controller: provider.textController,
                decoration: const InputDecoration(labelText: 'Enter some text'),
              ),
              const SizedBox(height: 16),

              // Date Selection Row
              Row(
                children: [
                  Text(
                    provider.selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${provider.selectedDate.toString()}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        provider.selectDate(pickedDate);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Google Map Widget for Current Location
              Container(
                height: 200,
                width: double.infinity,
                child: currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: currentPosition!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('currentLocation'),
                            position: currentPosition!,
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Image Picker Button
              ElevatedButton(
                onPressed: () {
                  provider.pickImages();
                },
                child: const Text('Pick Images'),
              ),

              // Display selected images
              provider.imageFiles == null || provider.imageFiles!.isEmpty
                  ? const Text('No images selected')
                  : SizedBox(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.imageFiles!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(provider.imageFiles![index].path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.isLoading
            ? null
            : () async {
                await provider.saveData();
                if (!provider.isLoading) {
                  Navigator.pop(context); // Navigate back after saving
                }
              },
        child: provider.isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
