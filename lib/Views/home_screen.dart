import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_nest/Providers/auth_provider.dart';
import 'package:do_nest/Providers/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: true,
    );

    final dataProvider= Provider.of<FirestoreDataProvider>(
      context,
      listen: true,
    );
    final TextEditingController tasktextController = TextEditingController();
    dev.log('Tasks: ${dataProvider.tasks.length}');

    String? userName = authProvider.userModel?.firstName ?? 'No user logged in';
    print(userName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              authProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
       child: dataProvider.isLoading
          ? const CircularProgressIndicator()
          : dataProvider.tasks.isEmpty ? Center(
            child: Text(
              'No tasks available. Please add a task.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ) :
       ListView.builder(
         itemCount: dataProvider.tasks.length,
         itemBuilder: (BuildContext context, int index) {
          dev.log('Fetching tasks for user: ${authProvider.userModel!.uId}');
             // Assuming each task is a DocumentSnapshot
           DocumentSnapshot task = dataProvider.tasks[index];
             return ListTile(
            title: Text(task['task']),
            leading: Checkbox(
              value: task['isCompleted'] ?? false,
              onChanged: (bool? value) {
                // Handle checkbox state change
                dataProvider.updateTaskCompletion(
                  authProvider.userModel!.uId!,
                  task.id,
                  value ?? false,
                );
              },
            ),
            trailing:  Text(task['createdAt'].toDate().toString(),
           ));
         },
       ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add task screen
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: TextField(
                decoration: const InputDecoration(hintText: 'Enter task'),
                controller: tasktextController,
              ),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text('Cancel')),
                TextButton(onPressed: () {
                  if (tasktextController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task cannot be empty')),
                    );}
                    else{
                      dataProvider.addTask(uid: authProvider.userModel!.uId!, task: tasktextController.text);
                  tasktextController.clear();
                  Navigator.of(context).pop();
                    }
                }, child: const Text('OK')),
                
              ],
            );
          },);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}