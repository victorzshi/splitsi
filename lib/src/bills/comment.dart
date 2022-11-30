import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.code,
    required this.timestamp,
    this.name,
    this.text,
  });

  final String? code;
  final String? timestamp;
  final String? name;
  final String? text;

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Comment(
      code: data?['code'],
      timestamp: data?['timestamp'],
      name: data?['name'],
      text: data?['text'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) "code": code,
      if (timestamp != null) "timestamp": timestamp,
      if (name != null) "name": name,
      if (text != null) "text": text,
    };
  }
}
