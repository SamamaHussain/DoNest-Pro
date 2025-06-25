import 'package:do_nest/Views/home_screen.dart';
import 'package:do_nest/Views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  FirebaseAuth.instance
  .authStateChanges(), 
    builder: (context, snapshot) {
      if(snapshot.hasData){
        return const HomeScreen();// if user is logged in
      }
        else if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else{
          return LoginScreen();// if user is not logged in
        }
    },);
  }
}