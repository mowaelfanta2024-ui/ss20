import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? authorId;
  String? authorEmail;
  String? content;
  List<String>? likes;

  PostModel({
    required this.authorId,
    required this.authorEmail,
    required this.content,
    required this.likes,
  });

  factory PostModel.fromFirestore(Map<String, dynamic> map) {
    return PostModel(
      authorId: map['authorId'],
      authorEmail: map['authorEmail'],
      content: map['content'],
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorEmail': authorEmail,
      'content': content,
      'likes': likes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}