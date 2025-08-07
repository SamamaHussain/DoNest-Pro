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
  required String title,
  required String descp,
}) async {
  try {
    final taskData = {
      'title': title,
      'descp': descp,
      'lastUpdated': FieldValue.serverTimestamp(),
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
        .orderBy('lastUpdated', descending: true)
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


Future<void> updateTask({
  required String uid,
  required String taskId,
  required String title,
  required String descp,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({
      'title': title,
      'descp': descp,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    dev.log('Task updated successfully for user: $uid, taskId: $taskId');
    await fetchTasks(uid);
  } catch (e) {
    dev.log('Error updating task: $e');
  }
  notifyListeners();
}

Future<void> deleteTask({
  required String uid,
  required String taskId,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    dev.log('Task deleted successfully for user: $uid, taskId: $taskId');
    await fetchTasks(uid);
  } catch (e) {
    dev.log('Error deleting task: $e');
  }
  notifyListeners();

}
}