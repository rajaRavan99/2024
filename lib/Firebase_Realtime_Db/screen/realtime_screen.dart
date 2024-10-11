import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_file.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Firebase Example')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          ElevatedButton(
            onPressed: () {
              itemProvider.addItem(_controller.text);
              _controller.clear();
            },
            child: const Text('Add Item'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) {
                final item = itemProvider.items[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _controller.text = item.name;
                          itemProvider.updateItem(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          itemProvider.deleteItem(item.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
