import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'bill.dart';

class BillService {
  static final collection =
      FirebaseFirestore.instance.collection("bills").withConverter(
            fromFirestore: Bill.fromFirestore,
            toFirestore: (bill, options) => bill.toFirestore(),
          );

  static Future<String> nextCode() async {
    var code = '';
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const length = 4;

    Future<bool> isNotUniqueCode() async {
      final query = await collection.where("code", isEqualTo: code).get();

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

  static void upload(Bill bill) async {
    await collection.add(bill);
  }

  static Future<Bill> fetch(String code) async {
    final query = await collection.where("code", isEqualTo: code).get();

    if (query.docs.isEmpty) {
      throw Exception('Bill not found');
    }

    if (query.docs.length != 1) {
      throw Exception('Bill has non-unique code');
    }

    final bill = query.docs.first.data();

    return bill;
  }

  static Future<void> setExampleData() async {
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

    await collection.doc('TEST').set(testBill);
    await collection.doc('SAME1').set(sameBill);
    await collection.doc('SAME2').set(sameBill);
    await collection.doc('NULL').set(nullBill);
  }
}
