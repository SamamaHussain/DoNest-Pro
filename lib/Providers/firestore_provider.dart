import 'dart:developer' as dev show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreDataProvider with ChangeNotifier{
List<DocumentSnapshot> _tasks = [];
List<DocumentSnapshot> get tasks => _tasks;
  bool isLoading = false;
  bool isCompleted = false;

  FirestoreDataProvider() {
    checkSession();
  }

  void checkSession() async{
    final currentUser =FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      await fetchTasks(currentUser.uid);
    }
    else {
      dev.log('No user is currently logged in.');
    }
  }

  Future<void> addTask({
  required String uid,
  required String task,
}) async {
  try {
    final taskData = {
      'task': task,
      'createdAt': FieldValue.serverTimestamp(),
      'isCompleted': false,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add(taskData);

    dev.log('Task added successfully for user: $uid');
  } catch (e) {
    dev.log('Error adding task: $e');
  }
  notifyListeners();
  await fetchTasks(uid);
}

Future<void> fetchTasks(String uid) async {
  isLoading = true;
  notifyListeners();
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .get();

    _tasks = querySnapshot.docs;
    dev.log('Tasks fetched successfully for user: $uid');
  } catch (e) {
    dev.log('Error fetching tasks: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<void> updateTaskCompletion(String uid, String taskId, bool isCompleted) async {
  this.isCompleted = isCompleted;
  notifyListeners();
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': isCompleted});

    dev.log('Task completion updated successfully for user: $uid, taskId: $taskId');
  await fetchTasks(uid);
  } catch (e) {
    dev.log('Error updating task completion: $e');
  }
}
}