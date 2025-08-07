import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_nest/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider with ChangeNotifier {
  UserModel? userModel;
  bool isLoading = false;

  FirebaseAuthProvider() {
    checkSession();
  }

  void checkSession() async{
    final currentUser =FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      await getUserData(currentUser.uid);
      dev.log('User is currently logged in: ${userModel?.uId}');
    }
    else {
      dev.log('No user is currently logged in.');
    }
  }

  Future<void> signUp(String emailAddress, String password,String firstName,String lastName) async {
     userModel = UserModel(email: emailAddress);
    try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: userModel!.email!,
    password: password,
  );
  if (credential.user != null) {
  userModel?.uId=credential.user?.uid;
  dev.log('User signed up: ${userModel?.uId}');
  saveUserData(emailAddress, firstName, lastName, userModel!.uId!);}
  else {
    dev.log('User sign up failed: No user returned');
  }
  notifyListeners();
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
     dev.log('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
     dev.log('The account already exists for that email.');
  }
} catch (e) {
   dev.log(e.toString());
}
  }

Future<bool> login (String emailAddress, String password)async {
  userModel = UserModel(email: emailAddress);
  dev.log('Logging in with email: ${userModel!.email}');
  try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: userModel!.email!,
    password: password
  );
  if (credential.user != null) {
    // userModel?.uId=credential.user?.uid;
       getUserData(credential.user!.uid);
    dev.log('User logged in: ${userModel?.firstName}');
    return true; // Login successful
  }
  notifyListeners();
  return false; // Login failed
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
     dev.log('No user found for that email.');
  } else if (e.code == 'wrong-password') {
     dev.log('Wrong password provided for that user.');
  }
  return false; // Login failed
} catch (e) {
   dev.log('Error logging in: $e');
   return false; // Login failed
}
  
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  } catch (e) {
     dev.log('Error signing out: $e');
  }
}

Future<void> saveUserData(String email,String firstName, String lastName, String uId) async{

  userModel = UserModel(
    uId: uId,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
  final userData={
    'uId': userModel?.uId,
    'firstName': userModel?.firstName,
    'lastName': userModel?.lastName,
    'email': userModel?.email,
  };
  dev.log('Saving user data: ${userModel?.uId}');
  try{
  await FirebaseFirestore.instance.collection('users').doc(userModel?.uId).set(userData);
  dev.log('User data saved successfully: $userData');
  notifyListeners();
  }
  catch (e) {
    dev.log('Error saving user data: $e');
  }
}

Future<void> getUserData(String uId) async {
      isLoading = true;
  notifyListeners();
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uId).get();
    if (doc.exists) {
      userModel = UserModel(
        uId: doc['uId'],
        firstName: doc['firstName'],
        lastName: doc['lastName'],
        email: doc['email'],
      );
      dev.log('User data retrieved successfully: ${userModel?.uId}');
     
    } else {
      dev.log('No user found for the given uId: $uId');
    }
  } catch (e) {
    dev.log('Error retrieving user data: $e');
  }
  finally {
    isLoading = false;
    notifyListeners(); // Moved notifyListeners() to finally block
  }


}
 notifyListeners();
}