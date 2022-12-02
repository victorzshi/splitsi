import 'package:cloud_firestore/cloud_firestore.dart';

/// If user is registered, we keep history of their bills (unique codes).
class Account {
  Account({
    this.codes,
  });

  final List<String>? codes;

  factory Account.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Account(
      codes: (data?['codes'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (codes != null) 'codes': codes,
    };
  }
}

class AccountService {
  static final collection =
      FirebaseFirestore.instance.collection('accounts').withConverter(
            fromFirestore: Account.fromFirestore,
            toFirestore: (bill, options) => bill.toFirestore(),
          );

  static Future<void> addCodes(String? uid, List<String> codes) async {
    if (uid == null || uid.isEmpty) {
      return;
    }

    final doc = await collection.doc(uid).get();

    if (doc.exists) {
      await collection.doc(uid).update({
        'codes': FieldValue.arrayUnion(codes),
      });
    } else {
      await collection.doc(uid).set(Account(codes: codes));
    }
  }

  static Future<List<String>> fetchCodes(String? uid) async {
    if (uid == null || uid.isEmpty) {
      return [];
    }

    final doc = await collection.doc(uid).get();

    if (doc.exists) {
      final account = doc.data();

      return account?.codes ?? [];
    }

    return [];
  }

  static Future<void> setTestData() async {
    const uid = 'TEST';
    final doc = await collection.doc(uid).get();

    if (doc.exists) return;

    final testAccount = Account(
      codes: ['TEST', 'SAME', 'NULL'],
    );

    await collection.doc(uid).set(testAccount);
  }
}
