import 'package:flutter/material.dart';
import 'package:note_app/DBHelper/database_helper.dart';
import 'package:note_app/Helper/BackOnTap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NoteApp(title: 'Note App'),
    );
  }
}

class NoteApp extends StatefulWidget {
  const NoteApp({super.key, required this.title});

  final String title;

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  List<Map<String, dynamic>> _allNotes = [];
  bool _isLoadingNote = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void showBottomSheetContent(int? id) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final noteData = {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'time': DateTime.now().toIso8601String(),
                      };
                      await QueryHelper.insertNote(noteData);
                      await _fetchNotes();
                      Backontap().onButtonTapped();
                    },
                    child: const Text('Add Note'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoadingNote = true;
    });
    try {
      _allNotes = await QueryHelper.getNotes();
    } catch (e) {
      if (e.toString().contains('no such table')) {
        final db = await QueryHelper.db();
        await QueryHelper.createTable(db);
        // Try again after creating the table
        _allNotes = await QueryHelper.getNotes();
      } else {
        _allNotes = [];
      }
    }
    setState(() {
      _isLoadingNote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_allNotes[index]['title'] ?? 'No Title'),
              subtitle: Text(
                _allNotes[index]['description'] ?? 'No Description',
              ),
              trailing: Text(_allNotes[index]['time'] ?? 'No Time'),
              onTap: () {
                _titleController.text = _allNotes[index]['title'] ?? '';
                _descriptionController.text =
                    _allNotes[index]['description'] ?? '';
                showBottomSheetContent(_allNotes[index]['id']);
              },
            );
          },
          itemCount: _allNotes.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          showBottomSheetContent(null);
        },
        tooltip: 'Adding a note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
