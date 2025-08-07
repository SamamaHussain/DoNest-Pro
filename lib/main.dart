import 'package:do_nest/Providers/firestore_provider.dart';
import 'package:do_nest/Views/home_screen.dart';
import 'package:do_nest/Views/login.dart';
import 'package:do_nest/Views/new_note_screen.dart';
import 'package:do_nest/Views/signup.dart';
import 'package:do_nest/auth_state.dart';
import 'package:do_nest/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_nest/Providers/auth_provider.dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreDataProvider(),)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoNest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthState(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/newNote': (context) => NewNoteScreen(),
      },
    );
  }
}
