import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  String _avatarUrl = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() ?? {};
    _name.text = data['name'] ?? '';
    _phone.text = data['phone'] ?? '';
    _avatarUrl = data['avatarUrl'] ?? '';
    setState(()=> _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 44,
                backgroundImage: _avatarUrl.isNotEmpty ? NetworkImage(_avatarUrl) : null,
                child: _avatarUrl.isEmpty ? const Icon(Icons.camera_alt, size: 32) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), controller: _name),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()), controller: _phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _save, child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    final file = File(picked.path);
    final ref = FirebaseStorage.instance.ref().child('avatars/${FirebaseAuth.instance.currentUser!.uid}.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    setState(()=> _avatarUrl = url);
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'avatarUrl': _avatarUrl,
    }, SetOptions(merge: true));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}
