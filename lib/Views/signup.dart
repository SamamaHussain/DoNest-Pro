import 'package:do_nest/Providers/auth_provider.dart';
import 'package:do_nest/Utils/Widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                TextField(
      controller: firstNameController,
      decoration: InputDecoration(labelText: 'First Name'),
    ),
    SizedBox(height: 12),
    TextField(
      controller: lastNameController,
      decoration: InputDecoration(labelText: 'Last Name'),
    ),
    SizedBox(height: 12),
    TextField(
      controller: emailController,
      decoration: InputDecoration(labelText: 'Email'),
    ),
    SizedBox(height: 12),
    TextField(
      controller: passwordController,
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
    ),
    SizedBox(height: 12),
    TextField(
      controller: confirmPasswordController,
      decoration: InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
    ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                if (firstName.isEmpty ||
                    lastName.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  showMessage(context, 'Please fill all the fields');
                  return;
                }

                final nameRegExp = RegExp(r'^[a-zA-Z]+$');
                if (!nameRegExp.hasMatch(firstName) ||
                    !nameRegExp.hasMatch(lastName)) {
                  showMessage(
                    context,
                    'First and last names must contain only letters',
                  );
                  return;
                }

                if (password != confirmPassword) {
                  showMessage(context, 'Passwords do not match');
                  return;
                }
                await authProvider.signUp(email, password, firstName, lastName);
              },
              child: Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                
              },
              child: Text('Alraeady have an account? Login Here.'),
            )
          ],
        ),
      ),
    );
  }
}
