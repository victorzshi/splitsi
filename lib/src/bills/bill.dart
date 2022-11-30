import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  Bill({
    required this.code,
    required this.timestamp,
    this.title,
    this.description,
  });

  final String? code;
  final String? timestamp;
  final String? title;
  final String? description;

  factory Bill.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Bill(
      code: data?['code'],
      timestamp: data?['timestamp'],
      title: data?['title'],
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) "code": code,
      if (timestamp != null) "timestamp": timestamp,
      if (title != null) "title": title,
      if (description != null) "description": description,
    };
  }
}
