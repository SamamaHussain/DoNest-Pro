import 'package:do_nest/Providers/auth_provider.dart';
import 'package:do_nest/Providers/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewNoteScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataProvider= Provider.of<FirestoreDataProvider>(
      context,
      listen: true,
    );
        final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: true,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable default back button
        title: const Text('New Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Custom back icon
          onPressed: () {
            if(_titleController.text.isNotEmpty || _contentController.text.isNotEmpty){
                          dataProvider.addTask(
             uid: authProvider.userModel!.uId!,
              title: _titleController.text,
              descp: _contentController.text,
            ).then((_) {
              Navigator.pop(context);
            }); // 👈 Go back manually
            } else {
              Navigator.pop(context); // Just go back if no content
            }
          },
        ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
              ),
            ),
            // if (isSaving) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}