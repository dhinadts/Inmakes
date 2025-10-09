import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/user/user_dashboard.dart';
import '../widgets/input_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Food App',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      InputTextFormField(
                        label: 'Email',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter email' : null,
                        decoration: InputDecoration(),
                      ),
                      const SizedBox(height: 12),
                      InputTextFormField(
                        label: 'Password',
                        controller: _password,
                        obscureText: true,
                        validator: (v) =>
                            (v == null || v.length < 6) ? 'Min 6 chars' : null,
                        decoration: InputDecoration(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _registerDialog(context),
                        child: const Text('Create an account'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Privacy Policy'),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Terms'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser!;
      final role =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get())
              .data()?['role'] ??
          'User';
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              role == 'Admin' ? const AdminDashboard() : const UserDashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _registerDialog(BuildContext context) {
    final name = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController(text: _email.text);
    final pass = TextEditingController();
    final isAdmin = ValueNotifier(false);
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Register'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputTextFormField(
                    label: 'Name',
                    controller: name,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter name' : null,
                    decoration: InputDecoration(),
                  ),
                  const SizedBox(height: 8),
                  InputTextFormField(
                    label: 'Phone',
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(),
                  ),
                  const SizedBox(height: 8),
                  InputTextFormField(
                    label: 'Email',
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter email' : null,
                    decoration: InputDecoration(),
                  ),
                  const SizedBox(height: 8),
                  InputTextFormField(
                    label: 'Password',
                    controller: pass,
                    obscureText: TrueBool.t,
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Min 6 chars' : null,
                    decoration: InputDecoration(),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<bool>(
                    valueListenable: isAdmin,
                    builder: (_, val, a) => CheckboxListTile(
                      value: val,
                      onChanged: (b) => isAdmin.value = b ?? false,
                      title: const Text('Register as Admin'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!key.currentState!.validate()) return;
                try {
                  final cred = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: email.text.trim(),
                        password: pass.text.trim(),
                      );
                  final uid = cred.user!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set({
                        'name': name.text.trim(),
                        'email': email.text.trim(),
                        'phone': phone.text.trim(),
                        'role': isAdmin.value ? 'Admin' : 'User',
                        'avatarUrl': '',
                      });
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registered! You can login now.'),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? 'Failed to register')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }
}

// Helper to allow const obscureText true
class TrueBool {
  static const t = true;
}
