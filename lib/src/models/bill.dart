import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

/// General bill-related info. Every bill has a unique code that identifies it.
/// Timestamp is used to calculate when the data should be removed from the
/// database.
class Bill {
  Bill({
    this.code,
    this.timestamp,
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
      if (code != null) 'code': code,
      if (timestamp != null) 'timestamp': timestamp,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
    };
  }
}

class BillService {
  static final collection =
      FirebaseFirestore.instance.collection('bills').withConverter(
            fromFirestore: Bill.fromFirestore,
            toFirestore: (bill, options) => bill.toFirestore(),
          );

  static Future<String> nextCode() async {
    var code = '';
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const length = 4;

    Future<bool> isNotUniqueCode() async {
      final query = await collection.where('code', isEqualTo: code).get();

      return query.docs.isNotEmpty;
    }

    do {
      for (var i = 0; i < length; i++) {
        final index = Random().nextInt(letters.length);
        code += letters[index];
      }
    } while (await isNotUniqueCode());

    return code;
  }

  static Future<void> upload(Bill bill) async {
    await collection.add(bill);
  }

  static Future<Bill> fetch(String code) async {
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isEmpty) {
      throw Exception('Bill not found');
    }

    if (query.docs.length != 1) {
      throw Exception('Bill has non-unique code');
    }

    final bill = query.docs.first.data();

    return bill;
  }

  static Future<void> setTestData() async {
    const code = 'TEST';
    final query = await collection.where('code', isEqualTo: code).get();

    if (query.docs.isNotEmpty) return;

    final timestamp = DateTime.now().toIso8601String();

    final testBill = Bill(
      code: code,
      timestamp: timestamp,
      title: 'Test bill',
      description: 'Contains dummy data',
    );
    final sameBill = Bill(
      code: 'SAME',
      timestamp: timestamp,
      title: 'Non-unique bill',
      description: 'Should throw exception',
    );
    final nullBill = Bill(
      code: 'NULL',
      timestamp: timestamp,
    );

    await collection.add(testBill);
    await collection.add(sameBill);
    await collection.add(sameBill);
    await collection.add(nullBill);
  }
}
