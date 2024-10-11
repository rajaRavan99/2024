import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';
import '../provider/user_provider.dart';

class UserScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                var user = userProvider.users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age: ${user.age}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      userProvider.deleteUser(user.id);
                    },
                  ),
                  onTap: () {
                    _nameController.text = user.name;
                    _ageController.text = user.age.toString();
                    _showUserDialog(context, userProvider, user: user);
                  },
                );
              },
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _nameController.clear();
              _ageController.clear();
              _showUserDialog(context, userProvider);
            },
          )
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context, UserProvider userProvider, {User? user}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Update User'),
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (user == null) {
                  // Add new user
                  userProvider.addUser(User(
                    id: '', // Firestore will generate ID
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                  ));
                } else {
                  // Update existing user
                  userProvider.updateUser(User(
                    id: user.id,
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                  ));
                }
                Navigator.of(context).pop();
              },
              child: Text(user == null ? 'Add' : 'Update'),
            )
          ],
        );
      },
    );
  }
}
