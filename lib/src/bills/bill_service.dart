import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'bill.dart';

class BillService {
  // Generate unique code
  static Future<String> nextCode() async {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const length = 4;

    var code = '';
    do {
      for (var i = 0; i < length; i++) {
        final index = Random().nextInt(letters.length);
        code += letters[index];
      }
    } while (await _isNotUniqueCode(code));

    return code;
  }

  // Add read-only bill to database
  static void upload(Bill bill) async {
    final db = FirebaseFirestore.instance;

    // TODO: Set data as read-only
    await db
        .collection("bills")
        .withConverter(
          fromFirestore: Bill.fromFirestore,
          toFirestore: (bill, options) => bill.toFirestore(),
        )
        .add(bill);
  }

  // Get single bill that has the unique code
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

  static Future<void> setExampleData() async {
    final db = FirebaseFirestore.instance;

    final billsRef = db.collection("bills").withConverter(
          fromFirestore: Bill.fromFirestore,
          toFirestore: (bill, options) => bill.toFirestore(),
        );

    final timestamp = DateTime.now().toIso8601String();

    final testBill = Bill(
      code: 'TEST',
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

    await billsRef.doc('TEST').set(testBill);
    await billsRef.doc('SAME1').set(sameBill);
    await billsRef.doc('SAME2').set(sameBill);
    await billsRef.doc('NULL').set(nullBill);
  }

  static Future<bool> _isNotUniqueCode(String code) async {
    final db = FirebaseFirestore.instance;

    final query = db.collection("bills").where("code", isEqualTo: code);

    final querySnap = await query.get();

    return querySnap.docs.isNotEmpty;
  }
}
