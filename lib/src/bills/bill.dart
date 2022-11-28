import 'dart:math';

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

  // Generate unique 4-letter code
  static String generateCode() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    var code = '';
    for (var i = 0; i < 4; i++) {
      final index = Random().nextInt(alphabet.length);
      code += alphabet[index];
    }

    // TODO: Check that code is unique in database
    // do while (code is in database)

    return code;
  }

  // TODO: Upload bill as read-only
  static void upload(Bill bill) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection("bills")
        .withConverter(
          fromFirestore: Bill.fromFirestore,
          toFirestore: (bill, options) => bill.toFirestore(),
        )
        .add(bill);
  }

  static Future<Bill> fetch(String code) async {
    final db = FirebaseFirestore.instance;

    final query = db.collection("bills").where("code", isEqualTo: code);

    final ref = query.withConverter(
      fromFirestore: Bill.fromFirestore,
      toFirestore: (bill, options) => bill.toFirestore(),
    );

    final querySnap = await ref.get();

    if (querySnap.docs.isEmpty) {
      throw Exception('Bill not found');
    }

    if (querySnap.docs.length != 1) {
      throw Exception('Bill has non-unique code');
    }

    final bill = querySnap.docs.first.data();
    return bill;
  }
}
