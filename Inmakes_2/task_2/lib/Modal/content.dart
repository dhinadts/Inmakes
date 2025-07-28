import 'package:cloud_firestore/cloud_firestore.dart';

class ContentModel {
  String id;
  String title;
  String description;

  ContentModel({required this.id, required this.title, required this.description});

  factory ContentModel.fromDoc(DocumentSnapshot doc) {
    return ContentModel(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
    );
  }
}
