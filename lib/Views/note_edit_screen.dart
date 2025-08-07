import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_nest/Providers/auth_provider.dart';
import 'package:do_nest/Providers/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditNoteScreen extends StatelessWidget {
   
  final DocumentSnapshot taskDoc;
  EditNoteScreen({super.key,
    required this.taskDoc,
  });
  @override
  Widget build(BuildContext context) {
        final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: true,
    );

    final dataProvider = Provider.of<FirestoreDataProvider>(
      context,
      listen: true,
    );
  TextEditingController _titleController=TextEditingController(text: taskDoc['title']);
  TextEditingController _contentController=TextEditingController(text: taskDoc['descp']);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()async {
            if(_titleController.text.isNotEmpty || _contentController.text.isNotEmpty){
              dataProvider.updateTask(
              uid: authProvider.userModel!.uId!,
              taskId: taskDoc.id,
              title: _titleController.text,
              descp: _contentController.text,
            ).then((_) {
              Navigator.pop(context);
            }); // 👈 Go back manually
            } else {
              dataProvider.deleteTask(uid: authProvider.userModel!.uId!, taskId: taskDoc.id).then((_) {
                 Navigator.pop(context); 
              });
             // Just go back if no content
            }
          }
        ),
        title: const Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}