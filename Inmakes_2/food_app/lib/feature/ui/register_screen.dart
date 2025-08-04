import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 Firestore

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isEmailValid(String email) {
    final pattern = RegExp(r'^[a-z0-9.]+@gmail\.com$');
    return pattern.hasMatch(email);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ✅ Register with Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passwordController.text.trim(),
          );

      // ✅ Get UID and store to Firestore
      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': _emailController.text.trim().toLowerCase(),
          'role': 'User', // or dynamically set 'Admin'
          'createdAt': Timestamp.now(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );
      Navigator.pop(context); // back to login
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-up error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _formKey,

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),

              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    onChanged: (val) {
                      _emailController.value = TextEditingValue(
                        text: val.toLowerCase(),
                        selection: TextSelection.collapsed(offset: val.length),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (!_isEmailValid(value ?? '')) {
                        return 'Enter a valid lowercase Gmail address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if ((value ?? '').length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
