import 'package:flu/vpn/add_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetScreen extends StatelessWidget {
  // Function to delete the document from Firestore
  Future<void> deleteItem(String documentId) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(documentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to AddScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                final item = doc.data() as Map<String, dynamic>;
                final List<String> images = item['images'] != null
                    ? List<String>.from(item['images'])
                    : [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Text: ${item['text']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Delete Icon
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Show confirmation dialog
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmDelete == true) {
                                  // Delete the item from Firestore
                                  await deleteItem(doc.id);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Date: ${item['date']}'),
                        const SizedBox(height: 16),

                        // Show the first image if available
                        images.isNotEmpty
                            ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Image.network(
                                    images[0], // First image
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 16),

                        // Show horizontal list of other images
                        images.length > 1
                            ? SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length - 1,
                                  itemBuilder: (context, imgIndex) {
                                    return Container(
                                      height: 100,
                                      width: 100.0,

                                      margin: EdgeInsets.symmetric(horizontal: 10.0),

                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 50,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(50.0)),
                                          child: Image.network(
                                            images[imgIndex + 1], // Other images
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
