import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  Bill({
    this.code,
    this.title,
    this.description,
    this.timestamp,
  });

  final String? code;
  final String? title;
  final String? description;
  final String? timestamp;

  factory Bill.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Bill(
      code: data?['code'],
      title: data?['title'],
      description: data?['description'],
      timestamp: data?['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) "code": code,
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (timestamp != null) "timestamp": timestamp,
    };
  }
}
