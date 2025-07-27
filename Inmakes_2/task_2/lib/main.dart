import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_2/UI/register_screen.dart';
import 'package:task_2/UI/user_dashboard.dart';
import 'package:task_2/firebase_options.dart';
import './UI/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // This line is crucial
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Task',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminHome(),
        '/user': (context) => const UserHome(),
      },
    );
  }
}
