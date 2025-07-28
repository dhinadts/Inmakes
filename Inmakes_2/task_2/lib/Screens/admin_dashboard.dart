import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_2/UI/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String role;
  final String? userId;

  const AdminDashboardScreen({super.key, required this.role, this.userId});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _addOrUpdateContent({
    required String imageUrl,
    required String title,
    required String description,
    String? docId,
  }) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('app_data')
          .doc('shared_content')
          .collection('content');

      final data = {
        'imageUrl': imageUrl,
        'title': title,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (docId == null) {
        await collectionRef.add(data);
      } else {
        await collectionRef.doc(docId).update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(docId == null ? 'Content added' : 'Content updated'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showContentDialog({
    String? docId,
    String? existingTitle,
    String? existingDesc,
    String? existingImageUrl,
  }) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController(
      text: existingTitle ?? '',
    );
    final TextEditingController _descController = TextEditingController(
      text: existingDesc ?? '',
    );
    final TextEditingController _imageUrlController = TextEditingController(
      text: existingImageUrl ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(docId == null ? 'Add Content' : 'Update Content'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image URL
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Image URL is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addOrUpdateContent(
                  docId: docId,
                  imageUrl: _imageUrlController.text.trim(),
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(docId == null ? 'Add Content' : 'Update Content'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteContent(String id) async {
    await FirebaseFirestore.instance
        .collection('app_data')
        .doc('shared_content')
        .collection('content')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.role == "Admin" ? "Admin Dashboard" : "User Dashboard",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: widget.role == 'Admin'
          ? FloatingActionButton(
              onPressed: () => _showContentDialog(),
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('app_data')
            .doc('shared_content')
            .collection('content')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No content available.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading:
                    data['imageUrl'] != null &&
                        data['imageUrl'].toString().isNotEmpty
                    ? Image.network(
                        data['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.image, size: 50),
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['description'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.role == 'Admin')
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showContentDialog(
                          docId: doc.id,
                          existingTitle: data['title'],
                          existingDesc: data['description'],
                          existingImageUrl: data['imageUrl'],
                        ),
                      ),
                    if (widget.role == 'Admin')
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteContent(doc.id),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
