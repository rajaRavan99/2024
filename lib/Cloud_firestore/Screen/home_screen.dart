// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_provider.dart';

class UploadFormScreen extends StatelessWidget {
  const UploadFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UploadFormProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload Data')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UploadFormProvider>(
            builder: (context, formProvider, child) {
              return Form(
                child: Column(
                  children: <Widget>[
                    // Text input field
                    TextFormField(
                      controller: formProvider.textController,
                      decoration:
                          const InputDecoration(labelText: 'Enter text'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    // Date picker row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formProvider.selectedDate == null
                                ? 'No date selected'
                                : 'Selected date: ${formProvider.selectedDate!.toLocal()}',
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, formProvider),
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),

                    // Location picker row
                    Row(
                      children: [
                        // Expanded(
                        //   child: Text(
                        //     formProvider.selectedLocation == null
                        //         ? 'No location selected'
                        //         : 'Location: (${formProvider.selectedLocation!.latitude}, ${formProvider.selectedLocation!.longitude})',
                        //   ),
                        // ),
                        TextButton(
                          onPressed: () => formProvider.setLocation(),
                          child: const Text('Select Location'),
                        ),
                      ],
                    ),

                    // Image picker buttons
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () => formProvider.pickImage(ImageSource.camera),
                        //   child: Text('Camera'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () => formProvider.pickImage(ImageSource.gallery),
                        //   child: Text('Gallery'),
                        // ),
                      ],
                    ),

                    // Image preview
                    formProvider.selectedImage != null
                        ? Image.file(formProvider.selectedImage!, height: 100)
                        : Container(),

                    const SizedBox(height: 20),

                    // Upload button
                    ElevatedButton(
                      onPressed: () => _uploadData(context, formProvider),
                      child: const Text('Upload'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Date picker
  Future<void> _selectDate(
      BuildContext context, UploadFormProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      provider.setDate(picked);
    }
  }

  // Upload data to Firebase
  Future<void> _uploadData(
      BuildContext context, UploadFormProvider formProvider) async {
    // if (formProvider.textController.text.isEmpty || formProvider.selectedDate == null || formProvider.selectedLocation == null || formProvider.selectedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    //   return;
    // }

    try {
      // final storageRef = FirebaseStorage.instance
      //     .ref()
      //     .child('uploads/${DateTime.now().toString()}.png');
      // await storageRef.putFile(formProvider.selectedImage!);
      // final downloadUrl = await storageRef.getDownloadURL();
      //
      // FirebaseFirestore.instance.collection('uploads').add({
      //   'text': formProvider.textController.text,
      //   'date': formProvider.selectedDate!.toIso8601String(),
      //   'location': GeoPoint(formProvider.selectedLocation!.latitude, formProvider.selectedLocation!.longitude),
      //   'image_url': downloadUrl,
      // });

      formProvider.clearForm();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload successful')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to upload data')));
    }
  }
}
